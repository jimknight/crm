class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  def index
    if current_user.admin?
      @prospects = Client.where(client_type: 'Prospect')
    else
      @prospects = current_user.clients.where(client_type: 'Prospect')
    end
    if params[:search].present?
      @prospects = @prospects.where('lower(name) LIKE ?', "%#{params[:search].downcase}%").order(:name, :city)
    else
      @prospects = @prospects.order(:name, :city)
    end
  end

  def new
    @prospect = Client.new
  end

  def create
    @prospect = Client.new(prospect_params)
    @prospect.client_type = "Prospect"
    respond_to do |format|
      if @prospect.save
        @prospect.users << current_user
        format.html { redirect_to prospect_path(@prospect), notice: 'Prospect was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def show
    if current_user.admin? || current_user.clients.include?(@prospect)
      if params[:user_id]
        @rep_activities = @prospect.activities.where(:user_id => params[:user_id])
      else
        @rep_activities = @prospect.activities
      end
    else
      redirect_to clients_path, :alert => "Unauthorized. Only marketing or admins and RSM's connected to this prospect can see this client"
    end
  end

private

  def set_prospect
    @prospect = Client.find(params[:id])
  end

  def set_tab
    @tab = "Prospect"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def prospect_params
    params.require(:client).permit(:name, :street1, :street2, :city, :state, :zip, :phone, :industry)
  end

end
