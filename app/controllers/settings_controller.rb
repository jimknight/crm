class SettingsController < ApplicationController
  before_action :hide_from_non_admins
  respond_to :html

  def new
    @setting = Setting.first
    if @setting.nil?
      @setting = Setting.new
    end
    respond_with(@setting)
  end

  def create
    @setting = Setting.new(setting_params)
    @setting.save
    redirect_to root_path, :notice => "Settings were updated."
  end

  def update
    @setting = Setting.find(params[:id])
    @setting.update(setting_params)
    redirect_to root_path, :notice => "Settings were updated."
  end

private
  def hide_from_non_admins
    if !current_user.admin?
      redirect_to root_path, :alert => "Not authorized. Only admins may edit the settings."
    end
  end

  def setting_params
    params.require(:setting).permit(:notify_on_new_prospect_contact,:notify_on_client_delete)
  end

end
