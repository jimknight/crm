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

  # no new because it's created when user created

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.save
    redirect_to profiles_path
  end

  def update
    @profile.update(profile_params)
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
      params.require(:profile).permit(:first_name, :last_name, :user_id)
    end
end
