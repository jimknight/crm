class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super do
      begin
        if !flash.nil? && flash["alert"] != "You need to sign in or have your adminstrator create your account before continuing." && !flash["alert"].nil?
          AuditLog.create_from_flash(flash, params, resource)
        end
      rescue
        puts "ERROR: #{@error_message}"
      end
    end
  end

  # POST /resource/sign_in
  def create
    super do
      begin
        AuditLog.create(params, resource)
      rescue
        puts "ERROR: #{@error_message}"
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      begin
        AuditLog.create(params, resource)
      rescue
        puts "ERROR: #{@error_message}"
      end
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
