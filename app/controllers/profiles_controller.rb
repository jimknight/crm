class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_tab
  respond_to :html

  def index
    if current_user.admin?
      @profiles = Profile.all.order(:first_name)
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
    @user = @profile.user
    if current_user.admin?
      if params[:search_activities].nil?
        @profile_activities = @user.activities
      else
        @profile_activities = @user.activities.search_activities(params[:search_activities]) # => [person_1, person_2]
      end
      @rsm_clients = @user.active_clients
      @rsm_prospects = @user.active_prospects
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
      @user = @profile.user
      if password_changed? && password_valid?
        admin = profile_params["admin"] == "1" ? true : false
        @user.update(user_params.merge(:admin => admin))
        @profile.update(:first_name => profile_params[:first_name], :last_name => profile_params[:last_name], :time_zone => profile_params[:time_zone])
        redirect_to profiles_path, :notice => "Profile and password updated."
      elsif password_changed? && password_invalid?
        render :edit
      else
        admin = profile_params["admin"] == "1" ? true : false
        @user.update(:admin => admin)
        @profile.update(:first_name => profile_params[:first_name], :last_name => profile_params[:last_name], :time_zone => profile_params[:time_zone])
        redirect_to profiles_path, :notice => "Profile updated."
      end
    else
      redirect_to profiles_path, :alert => "Unauthorized. Only admins can update profiles."
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_path
  end

  def reset_password
    if current_user.admin?
      @profile = Profile.find(params[:id])
      @user = @user
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

  def password_changed?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

  def password_valid?
    return false if user_params[:password] != user_params[:password_confirmation]
    return false if user_params[:password].length < 8
    return true
  end

  def password_invalid?
    if user_params[:password] != user_params[:password_confirmation]
      @profile.errors[:base] << "The passwords don't match. Please retry."
      return true
    end
    if user_params[:password].length < 8
      @profile.errors[:base] << "The password is too short. It needs to be at least 8 characters long."
      return true
    end
    return false
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :user_id, :admin, :role, :time_zone)
  end

  def user_params
    params.require(:profile).permit(:password,:password_confirmation)
  end

end
