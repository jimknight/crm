class ModelsController < ApplicationController
  before_action :hide_from_marketing
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  # GET /models
  # GET /models.json
  def index
    @models = Model.all.order("name")
  end

  # GET /models/1
  # GET /models/1.json
  def show
    if current_user.admin?
      @model_activities = @model.activities #all
    else
      @model_activities = @model.activities.where(:user_id => current_user.id) # user's activities
    end
    # TODO: Make this some simpler join thing that I don't know right now
    @activities_clients = []
    @model_activities.each do |activity|
      client = Client.find(activity.client_id)
      @activities_clients << client
    end
    @activities_clients.uniq! {|p| p.name}
    @activities_clients.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models
  def create
    @model = Model.new(model_params)
    if current_user.admin?
      if @model.save
        redirect_to models_path, notice: 'Model was successfully created.'
      else
       render :new
      end
    else
      redirect_to model_path(@model), alert: 'You must be an admin to create a model.'
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    if current_user.admin?
      respond_to do |format|
        if @model.update(model_params)
          format.html { redirect_to models_path, notice: 'Model was successfully updated.' }
          format.json { render :show, status: :ok, location: @model }
        else
          format.html { render :edit }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to model_path(@model), alert: 'You must be an admin to update a model.'
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    if current_user.admin?
      @model.destroy
      respond_to do |format|
        format.html { redirect_to models_url, notice: 'Model was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to model_path(@model), alert: 'You must be an admin to delete a model.'
    end
  end

  private
    def hide_from_marketing
      if current_user.marketing? && !current_user.admin?
        redirect_to prospects_path, :alert => "Not authorized. Users who are in the marketing role may not access models."
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = Model.find(params[:id])
    end

    def set_tab
      @tab = "Models"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      params.require(:model).permit(:name)
    end
end
