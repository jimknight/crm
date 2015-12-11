class OutsidersController < ApplicationController
  before_action :set_outsider, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def new
    @prospect = Client.find(params[:prospect_id])
    @outsider = Outsider.new
    respond_with(@outsider)
  end

  def create
    @prospect = Client.find(params[:outsider][:client])
    @outsider = Outsider.new(outsider_params)
    @outsider.client_id = params[:outsider][:client].to_i
    if @outsider.save
      UserMailer.notify_outsider_of_prospect(@prospect,@outsider,current_user).deliver # email alert
      redirect_to prospect_path(@prospect), :notice => "Prospect has been assigned and details were emailed to #{@outsider.email}."
    end
  end

  private
    def set_outsider
      @outsider = Outsider.find(params[:id])
    end

    def outsider_params
      params.require(:outsider).permit(:email, :first_name, :last_name)
    end
end
