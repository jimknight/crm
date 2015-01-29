class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_tab
  respond_to :html

  def index
    @profiles = Profile.all
    respond_with(@profiles)
  end

  def show
    respond_with(@profile)
  end

  def edit
    # if not admin and not user, cancel
    if @profile.user != current_user && !current_user.admin?
      redirect_to profiles_path, :notice => "You are not authorized to edit a profile other than your own."
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.save
    redirect_to profiles_path
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
