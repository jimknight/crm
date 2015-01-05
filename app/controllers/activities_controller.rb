class ActivitiesController < ApplicationController
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
    if current_user.activity_ids.include?(params[:id].to_i) || current_user.admin?
      @activity = current_user.activities.find(params[:id])
    else
      redirect_to root_path, :alert => "Not authorized"
    end
  end

  # GET /activities/new
  def new
    if params[:client]
      @client = Client.find(params[:client])
    else
      @client = Client.new
    end
    @activity = Activity.new(:activity_date => Date.today)
  end

  # GET /activities/1/edit
  def edit
     if current_user.activity_ids.include?(params[:id].to_i) || current_user.admin?
      @activity = current_user.activities.find(params[:id])
      @client = @activity.client
    else
      redirect_to root_path, :alert => "Not authorized"
    end
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        current_user.activities << @activity
        if params[:activity][:models].present?
          @model = Model.find(params[:activity][:models])
          @activity.models << @model
        end
        format.html { redirect_to activities_path, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
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
    if current_user.activities.include?(params[:id]) || current_user.admin?
      @activity = current_user.activities.find(params[:id])
    else
      redirect_to root_path, :notice => "Not authorized"
    end
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def set_tab
      @tab = "Activities"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:client_id, :activity_date, :contact_id, :city, :state, :industry, :comments)
    end
end
