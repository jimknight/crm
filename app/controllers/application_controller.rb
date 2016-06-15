class ApplicationController < ActionController::Base

  around_filter :user_time_zone, :if => :current_user

  # Devise https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  before_filter :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u|
      u.permit(:password, :password_confirmation, :current_password)
    }
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:admin?)
  end

  def user_time_zone(&block)
    if current_user.profile.time_zone.nil?
      Time.use_zone(Time.zone, &block)
    else
      Time.use_zone(current_user.profile.time_zone, &block)
    end
  end

  rescue_from SecurityError do |exception|
    redirect_to root_path, :alert => "Not authorized. Only administrators can see the admin dashboard."
  end

end
