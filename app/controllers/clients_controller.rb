class ClientsController < ApplicationController

  before_action :hide_from_marketing
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  def archive
    if current_user.admin?
      @client = Client.find(params[:id])
    else
      @client = current_user.clients.find(params[:id])
    end
    @client.status = "Archived"
    @client.save!
    redirect_to @client, :notice => "This client has been archived. You may un-archive later if you need to."
  end

  def un_archive
    if current_user.admin?
      @client = Client.find(params[:id])
    else
      @client = current_user.clients.find(params[:id])
    end
    @client.status = "Active"
    @client.save!
    redirect_to @client, :notice => "This client has been un-archived and set to active."
  end

  def index_archived
    if current_user.admin?
      @clients = Client.where(status: 'Archived').where.not(client_type: 'Prospect')
    else
      @clients = current_user.clients.where(status: 'Archived').where.not(client_type: 'Prospect')
    end
    if params[:search].present?
      @clients = @clients.where('lower(name) LIKE ?', "%#{params[:search].downcase}%").order(:name, :city)
    else
      @clients = @clients.order(:name, :city)
    end
  end

  def index
    if current_user.admin?
      @clients = Client.where(status: 'Active').where.not(client_type: 'Prospect')
    else
      @clients = current_user.clients.where(status: 'Active').where.not(client_type: 'Prospect')
    end
    if params[:search_state].present?
      @clients = @clients.where('lower(state) LIKE ?', "%#{params[:search_state].downcase}%").order(:name, :city)
    elsif params[:search_name].present?
      @clients = @clients.where('lower(name) LIKE ?', "%#{params[:search_name].downcase}%").order(:name, :city)
    elsif params[:search_city].present?
      @clients = @clients.where('lower(city) LIKE ?', "%#{params[:search_city].downcase}%").order(:name, :city)
    elsif params[:search_zip].present?
      @clients = @clients.where('lower(zip) LIKE ?', "%#{params[:search_zip].downcase}%").order(:name, :zip)
    elsif params[:search_phone].present?
      @clients = @clients.where('lower(phone) LIKE ?', "%#{params[:search_phone].downcase}%").order(:name, :city)
    elsif params[:search].present?
      @clients = @clients.where('lower(name) LIKE ?', "%#{params[:search].downcase}%").order(:name, :city)
    else
      @clients = @clients.order(:name, :city)
    end
  end

  def show
    if current_user.admin? || current_user.clients.include?(@client)
      if params[:user_id]
        @rep_activities = @client.activities.where(:user_id => params[:user_id])
      else
        @rep_activities = @client.activities
      end
      respond_to do |format|
        format.html
        format.json { render json: @client.to_json(include: :contacts) }
      end
    else
      redirect_to clients_path, :alert => "Unauthorized. Only admins and RSM's connected to this client can see this client"
    end
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        @client.users << current_user
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # Admins can delete but users can only request
  def destroy
    if current_user.admin?
      @client.destroy
      redirect_to clients_url, notice: 'Client was successfully destroyed.'
    else
      @recipients = Setting.get_notify_on_client_delete_recipients
      if !@recipients.present?
        @recipients = "dalmeida@mixers.com"
      end
      UserMailer.notify_on_client_delete(@client,@recipients,current_user).deliver_now
      redirect_to @client, notice: "An email was sent to #{@recipients} about your request to delete this client."
    end
  end

  def add_rsm_to_client
    @client = Client.find(params[:id])
    if params[:user_id].nil?
      @profiles = Profile.all.order(:first_name,:last_name)
    else
      @user = User.find(params[:user_id])
      @client.users << @user
      redirect_to @client, notice: "#{@user.user_name} was added to this client."
    end
  end

  def remove_rsm_from_client
    @client = Client.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user.admin?
      @client.users.delete(@user)
      redirect_to @user.profile, notice: "Removed #{@client.name} from #{@user.user_name}'s list of clients"
    else
      if current_user == @user
        @client.users.delete(current_user)
        redirect_to @user.profile, notice: "Removed #{@client.name} from your list of clients"
      else
        redirect_to @user.profile, alert: "Only admin's can remove clients from users' profiles."
      end
    end
  end

  private
  def hide_from_marketing
    if current_user.marketing? && !current_user.admin?
      redirect_to prospects_path, :alert => "Not authorized. Users who are in the marketing role may not access clients."
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  def set_tab
    @tab = "Client"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :country, :comments, :street1, :street2, :city, :state, :zip, :phone, :industry)
  end

end
