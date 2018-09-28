# == Schema Information
#
# Table name: audit_logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  action     :string
#  email      :string
#  controller :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuditLog < ActiveRecord::Base

  def self.create(params, resource)
    if resource == nil
      audit_log_params = {user_id: params["current_user"], action: params["action"], controller: params["controller"]}
    else
      audit_log_params = {user_id: resource.id, action: params["action"], email: resource.email, controller: params["controller"]}
    end
    save_audit_log(audit_log_params)
  end

  def self.create_from_flash(flash, params, resource)
    audit_log_params = {message: flash["alert"], action: params["action"], email: resource.email, controller: params["controller"]}
    save_audit_log(audit_log_params)
  end

private
  def self.save_audit_log(audit_log_params)
    @audit_log = AuditLog.new(audit_log_params)
    if @audit_log.save
      puts "Audit Log saved"
    else
      puts "Audit Log NOT saved"
      puts @audit_log.errors
    end
  end

end
