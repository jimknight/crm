class AuditLogsController < ApplicationController

  def index
    if current_user.admin?
      @audit_logs = AuditLog.all.order("created_at DESC").page params[:page]
      @tab = "AuditLogs"
    else
      redirect_to root_path, :alert => "Not authorized"
    end
  end

end
