class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_tab
  respond_to :html

  def index
    if current_user.admin?
      @profiles = Profile.all
      respond_with(@profiles)
    else
      redirect_to root_path, :alert => "Not authorized. Only administrators can view RSM's."
    end
  end

  def new
    if current_user.admin?
      @profile = Profile.new
    else
      redirect_to root_path, :alert => "Not authorized. Only administrators can create new RSM's."
    end
  end

  def show
    if current_user.admin?
      respond_with(@profile)
    else
      redirect_to root_path, :alert => "Not authorized. Only administrators can view RSM's."
    end
  end

  def edit
    if !current_user.admin?
      redirect_to root_path, :alert => "Not authorized. Only administrators can create edit RSM's."
    end
  end

  def create
    @profile = Profile.new(profile_params)
    if !current_user.admin?
      redirect_to profiles_path, :alert => "Only administrators can create new RSM's."
    elsif params["password"] != params["password_confirmation"]
      redirect_to :back, :alert => "Your passwords don't match"
    elsif params[:email].blank? || profile_params["first_name"].blank? || profile_params["last_name"].blank?
      redirect_to :back, :alert => "All fields are required. Please try again."
    else
      @user = User.new(:admin => params[:admin], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
      if params[:role] == "1"
        @user.role = "Marketing" # down the road if other roles, have to accommodate here
      end
      if @user.save
        @profile = @user.profile
        @profile.update_attributes(profile_params)
        redirect_to profiles_path
      else
        @user.errors.full_messages.each do |msg|
          @profile.errors.add(:base,msg)
        end
        render :action => :new
      end
    end
  end

  def update
    if current_user.admin?
      if profile_params["admin"] == "1"
        @profile.user.update_attribute("admin",true)
      else
        @profile.user.update_attribute("admin",false)
      end
      if params[:role] == "1" # down the road if other roles, have to accommodate here
        @profile.user.update_attribute("role","Marketing")
      else
        @profile.user.update_attribute("role","")
      end
      @profile.update(profile_params.tap{|x| x.delete(:admin)})
    else
      @profile.update(profile_params)
    end
    redirect_to profiles_path
  end

  def destroy
    @profile.destroy
    redirect_to profiles_path
  end

  def reset_password
    if current_user.admin?
      @profile = Profile.find(params[:id])
      @user = @profile.user
      @user.send_reset_password_instructions
      redirect_to profiles_path, :alert => "You have successfully reset the password for #{@profile.first_name} #{@profile.last_name}. They have been sent reset instructions via email."
    else
      redirect_to profiles_path, :alert => "You are not authorized to reset passwords for RSM's."
    end
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_tab
      @tab = "RSM's"
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :user_id, :admin, :role)
    end
end
