class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_tab
  respond_to :html

  def index
    @profiles = Profile.all
    respond_with(@profiles)
  end

  def new
    if current_user.admin?
      @profile = Profile.new
    else
      redirect_to profiles_path, :alert => "Only administrators can create new reps."
    end
  end

  def show
    respond_with(@profile)
  end

  def edit
    # if not admin and not user, cancel
    if @profile.user != current_user && !current_user.admin?
      redirect_to profiles_path, :alert => "You are not authorized to edit a profile other than your own."
    end
  end

  def create
    if !current_user.admin?
      redirect_to profiles_path, :alert => "Only administrators can create new reps."
    elsif params["password"] != params["password_confirmation"]
      redirect_to :back, :alert => "Your passwords don't match"
    elsif params[:email].blank? || profile_params["first_name"].blank? || profile_params["last_name"].blank?
      redirect_to :back, :alert => "All fields are required. Please try again."
    else
      @user = User.new(:admin => params[:admin], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
      if @user.save!
        @profile = @user.profile
        @profile.update_attributes(profile_params)
        redirect_to profiles_path
      else
        render :new
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

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_tab
      @tab = "Reps"
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :user_id, :admin)
    end
end
