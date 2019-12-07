class RsmsController < ApplicationController

  def new
    @prospect = Client.find(params[:prospect_id])
    @profiles = Profile.all.order(:first_name, :last_name)
  end

  def create
    @prospect = Client.find(params[:prospect_id])
    if params["rsm_ids"].nil?
      redirect_to new_prospect_rsm_path(@prospect), :alert => "You forgot to choose at least one RSM to assign to this prospect."
    else
      rsms = params["rsm_ids"].collect{|x| User.find(x)}
      @prospect.users << rsms
      rsm_emails = rsms.collect{|x| x.email}
      UserMailer.notify_rsm_new_prospect_contact_assignment(@prospect,rsm_emails,current_user).deliver_now # email alert
      if rsms.count > 1
        redirect_to prospects_path, notice: "#{rsms.count} RSMs were added to the #{@prospect.name} prospect."
      else
        redirect_to prospects_path, notice: "1 RSM was added to the #{@prospect.name} prospect."
      end
    end
  end

end
