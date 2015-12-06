class ProspectsController < ApplicationController
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  def index
    @prospects = Client.unassigned_prospects
    if params[:search_state].present?
      @prospects = @prospects.where('lower(state) LIKE ?', "%#{params[:search_state].downcase}%").order(:name, :city)
    elsif params[:search_name].present?
      @prospects = @prospects.where('lower(name) LIKE ?', "%#{params[:search_name].downcase}%").order(:name, :city)
    elsif params[:search_city].present?
      @prospects = @prospects.where('lower(city) LIKE ?', "%#{params[:search_city].downcase}%").order(:name, :city)
    elsif params[:search_phone].present?
      @prospects = @prospects.where('lower(phone) LIKE ?', "%#{params[:search_phone].downcase}%").order(:name, :city)
    elsif params[:search].present?
      @prospects = @prospects.where('lower(name) LIKE ?', "%#{params[:search].downcase}%").order(:name, :city)
    else
      @prospects = @prospects.order(:import_datetime)
    end
  end

  def new
    if current_user.admin? || current_user.marketing?
      @prospect = Client.new
    else
      redirect_to root_path, :alert => "Not authorized. Only administrators or a user with the marketing role can create new prospects."
    end
  end

  def create
    if current_user.admin? || current_user.marketing?
      @prospect = Client.new(prospect_params)
      @prospect.client_type = "Prospect"
      if @prospect.save
        redirect_to prospects_path, notice: 'Prospect was successfully created.'
      else
        render :new
      end
    else
      redirect_to root_path, :alert => "Not authorized. Only administrators or a user with the marketing role can create new prospects."
    end
  end

  def edit
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

  def update
    if @prospect.update(prospect_params)
      redirect_to prospect_path(@prospect), notice: 'Prospect was successfully updated.'
    else
      render :edit
    end
  end

  def convert_to_client
    @prospect = Client.find(params[:id])
    @prospect.client_type = "Client"
    @prospect.status = "Active"
    @prospect.save!
    redirect_to client_path(@prospect), notice: "Converted this prospect to an active client"
  end

  def add_rsm_to_prospect
    @prospect = Client.find(params[:id])
    if params[:user_id].nil?
      @profiles = Profile.all.order(:first_name,:last_name)
    else
      @rsm = User.find(params[:user_id])
      @prospect.users << @rsm
      UserMailer.notify_rsm_new_prospect_contact_assignment(@prospect,@rsm,current_user).deliver # email alert
      redirect_to prospect_path(@prospect), notice: "#{@rsm.user_name} was added to this prospect."
    end
  end

  def remove_rsm_from_prospect
    @prospect = Client.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user.admin?
      @prospect.users.delete(@user)
      redirect_to @user.profile, notice: "Removed #{@prospect.name} from #{@user.user_name}'s list of prospects"
    else
      if current_user == @user
        @prospect.users.delete(current_user)
        redirect_to @user.profile, notice: "Removed #{@prospect.name} from your list of prospects"
      else
        redirect_to @user.profile, alert: "Only admin's can remove prospects from users' profiles."
      end
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
    params.require(:client).permit(:name, :comments, :street1, :street2, :city, :state, :zip, :phone, :industry)
  end

end
