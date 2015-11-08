class ActivitiesController < ApplicationController
  before_action :hide_from_marketing
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  # GET /activities
  # GET /activities.json
  def index
    if current_user.admin?
      @activities = Activity.all.order("activity_date DESC")
    else
      @activities = current_user.activities.order("activity_date DESC")
    end
  end

  # GET /activities/1
  def show
    if current_user.activity_ids.include?(params[:id].to_i)
      @activity = current_user.activities.find(params[:id])
    elsif current_user.admin?
      @activity = Activity.find(params[:id])
    else
      redirect_to root_path, :alert => "Not authorized"
    end
  end

  # GET /activities/new
  def new
    if params[:client].present?
      @client = Client.find(params[:client])
    else
      @client = Client.new
    end
    if current_user.admin?
      @clients = Client.all.order(:name)
    else
      @clients = current_user.clients.all.order(:name)
    end
    @activity = Activity.new(:activity_date => Date.today)
  end

  # GET /activities/1/edit
  def edit
   if current_user.activity_ids.include?(params[:id].to_i)
      @activity = current_user.activities.find(params[:id])
    elsif current_user.admin?
      @activity = Activity.find(params[:id])
    else
      redirect_to root_path, :alert => "Not authorized"
    end
    @client = @activity.client
    if current_user.admin?
      @clients = Client.all.order(:name)
    else
      @clients = current_user.clients.all.order(:name)
    end
  end

  def create
    # Allow save with no contact
    @activity = Activity.new(activity_params)
    if params[:new_contact].present? && params[:activity][:client_id].present?
      @client = Client.find(params[:activity][:client_id])
      @contact = Contact.where(:name => params[:new_contact]).first_or_create
      @client.contacts << @contact
      @activity.update_attribute(:contact_id, @contact.id)
    end
    if @activity.save
      current_user.activities << @activity
      if params[:activity][:models].present?
        @model = Model.find(params[:activity][:models])
        @activity.models << @model
      end
      redirect_to activities_path, notice: 'Activity was successfully created.'
    else
      if activity_params[:client_id].present?
        @client = Client.find(activity_params[:client_id])
      else
        @client = Client.new
      end
      render :new
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        if params[:activity][:models].present?
          @model = Model.find(params[:activity][:models])
          @activity.models << @model
        end
        if params[:new_contact].present?
          @client = Client.find(params[:activity][:client_id])
          @contact = Contact.where(:name => params[:new_contact]).first_or_create
          @client.contacts << @contact
          @activity.update_attribute(:contact_id, @contact.id)
        end
        format.html { redirect_to activities_path, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    if current_user.activity_ids.include?(params[:id].to_i)
       @activity = current_user.activities.find(params[:id])
     elsif current_user.admin?
       @activity = Activity.find(params[:id])
    else
      redirect_to root_path, :notice => "Not authorized"
    end
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def hide_from_marketing
      if current_user.marketing? && !current_user.admin?
        redirect_to prospects_path, :alert => "Not authorized. Users who are in the marketing role may not access activities."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def set_tab
      @tab = "Activities"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:attachment, :attachment_cache, :client_id, :activity_date, :contact_id, :city, :remove_attachment, :state, :industry, :comments)
    end
end
