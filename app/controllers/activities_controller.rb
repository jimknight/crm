class ActivitiesController < ApplicationController
  before_action :hide_from_marketing
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_tab
  autocomplete :client, :name, :extra_data => [:city,:state,:country], :display_value => :name_and_location

  # Scope autocomplete to clients for that user
  def get_autocomplete_items(parameters)
    items = super(parameters)
    if current_user.admin?
      items
    else
      items.includes(:users).where(users:{id: current_user.id})
    end
  end

  def index
    if current_user.admin?
      @activities = Activity.all.order("activity_date DESC").page params[:page]
    else
      @activities = current_user.activities.order("activity_date DESC").page params[:page]
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
    @activity_attachments = @activity.activity_attachments.all
  end

  def new
    if params[:client].present?
      @client = Client.find(params[:client])
    else
      @client = Client.new
    end
    if current_user.admin?
      @clients = Client.all.order(:name,:city)
    else
      @clients = current_user.clients.all.order(:name,:city)
    end
    @activity = Activity.new(:activity_date => Date.today)
    @activity_attachment = @activity.activity_attachments.build
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
      @clients = Client.all.order(:name,:city)
    else
      @clients = current_user.clients.all.order(:name,:city)
    end
  end

  def create
    @activity = Activity.new(activity_params)
    if valid_client_choice?
      # Allow save with no contact
      if params[:new_contact].present? && activity_params[:client_id].present?
        @client = Client.find(activity_params[:client_id])
        @contact = Contact.where(:name => params[:new_contact]).first_or_create
        @client.contacts << @contact
        @activity.update_attribute(:contact_id, @contact.id)
      end
      if @activity.save
        if !params[:activity_attachments].nil?
          params[:activity_attachments]['attachment'].each do |a|
            @activity_attachment = @activity.activity_attachments.create!(:attachment => a)
          end
        end
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
    else
      if activity_params[:client_id].present?
        @client = Client.find(activity_params[:client_id])
      else
        @client = Client.new
      end
      @activity.errors[:base] << "The client you entered '#{params[:client_name]}' doesn't exist yet. Please choose from the existing clients or create a new client first. Then retry."
      render :new
    end
  end

  def create_old
    # Verify client exists first because of the type-ahead
    @client = Client.find(params[:client_id_val])
    if @client.nil?
      @activity.errors[:base] = "The client you entered '#{params[:client_id_val]}' doesn't exist yet. Please create the client first."
      render :new
    else
      # Allow save with no contact
      @activity = Activity.new(activity_params.merge(:client_id => params[:client_id_val]))
      if params[:new_contact].present? && params[:client_id_val].present?
        @client = Client.find(params[:client_id_val])
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
        render :new
      end
    end
  end

  def update
    # Verify client exists first because of the type-ahead
    if !valid_client_choice?
      @activity.errors[:base] = "The client you entered '#{params[:client_name]}' doesn't exist yet. Please choose from the existing clients or create a new client first. Then retry."
      render :edit
    else
      if @activity.update(activity_params)
        if !params[:remove_activity_attachments].nil?
          params[:remove_activity_attachments].each do |aa_id|
            aa = @activity.activity_attachments.find(aa_id)
            aa.destroy
          end
        end
        if !params[:activity_attachments].nil?
          params[:activity_attachments]['attachment'].each do |a|
            @activity_attachment = @activity.activity_attachments.create!(:attachment => a)
          end
        end
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
        redirect_to activities_path, notice: 'Activity was successfully updated.'
      else
        render :edit
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

  def valid_client_choice?
    if params[:client_name].present? && activity_params[:client_id].present?
      @client = Client.find(activity_params[:client_id])
      if @client.name_and_location == params[:client_name]
        return true
      else
        return false
      end
    elsif activity_params[:client_id].present?
      @client = Client.find(activity_params[:client_id])
      return true
    else
      return false
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_params
    params.require(:activity).permit(:attachment_cache, :client_id, :activity_date, :contact_id, :city, :remove_activity_attachments, :state, :industry, :comments, activity_attachment_attributes: [:id, :activity_id, :attachment])
  end
end
