class ApplicationController < ActionController::Base

  # Devise https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  before_filter :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
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

  rescue_from SecurityError do |exception|
    redirect_to root_path, :alert => "Not authorized. Only administrators can see the admin dashboard."
  end

end