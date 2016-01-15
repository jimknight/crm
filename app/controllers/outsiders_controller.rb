class OutsidersController < ApplicationController

  respond_to :html

  def new
    @prospect = Client.find(params[:prospect_id])
    @outsider = Outsider.new
    respond_with(@outsider)
  end

  def create
    @prospect = Client.find(params[:outsider][:client])
    @outsider = Outsider.find_by_email(outsider_params[:email])
    if @outsider.nil?
      @outsider = Outsider.new(outsider_params)
      if @outsider.save
        @prospect.outsiders << @outsider
        UserMailer.notify_outsider_of_prospect(@prospect,@outsider,current_user).deliver_now # email alert
        redirect_to prospect_path(@prospect), :notice => "Prospect has been assigned and details were emailed to #{@outsider.email}."
      end
    else
      @outsider.update_attributes!(outsider_params)
      if !@prospect.outsiders.include?(@outsider)
        @prospect.outsiders << @outsider
      end
      UserMailer.notify_outsider_of_prospect(@prospect,@outsider,current_user).deliver_now # email alert
      redirect_to prospect_path(@prospect), :notice => "Prospect has been assigned and details were emailed to #{@outsider.email}."
    end
  end

  private
    def outsider_params
      params.require(:outsider).permit(:email, :first_name, :last_name)
    end

end
