class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  # GET /clients
  # GET /clients.json
  def index
    if current_user.admin?
      @clients = Client.all
    else
      @clients = current_user.clients.all
    end
    if params[:search].present?
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

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    def set_tab
      @tab = "Client"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :street1, :street2, :city, :state, :zip, :phone, :industry)
    end

end
