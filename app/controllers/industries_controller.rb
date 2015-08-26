class IndustriesController < ApplicationController
  before_action :set_industry, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  # GET /industries
  # GET /industries.json
  def index
    @industries = Industry.all.order("name")
  end

  # GET /industries/1
  # GET /industries/1.json
  def show
    @industry_clients = Client.where(:industry => @industry.id.to_s).order("name")
  end

  # GET /industries/new
  def new
    @industry = Industry.new
  end

  # GET /industries/1/edit
  def edit
  end

  # POST /industries
  # POST /industries.json
  def create
    @industry = Industry.new(industry_params)
    if current_user.admin?
      respond_to do |format|
        if @industry.save
          format.html { redirect_to industries_path, notice: 'Industry was successfully created.' }
          format.json { render :show, status: :created, location: @industry }
        else
          format.html { render :new }
          format.json { render json: @industry.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to industry_path(@industry), alert: 'You must be an admin to create an industry.'
    end
  end

  # PATCH/PUT /industries/1
  # PATCH/PUT /industries/1.json
  def update
    if current_user.admin?
      respond_to do |format|
        if @industry.update(industry_params)
          format.html { redirect_to industries_path, notice: 'Industry was successfully updated.' }
          format.json { render :show, status: :ok, location: @industry }
        else
          format.html { render :edit }
          format.json { render json: @industry.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to industry_path(@industry), alert: 'You must be an admin to update an industry.'
    end
  end

  # DELETE /industries/1
  # DELETE /industries/1.json
  def destroy
    if current_user.admin?
      @industry.destroy
      respond_to do |format|
       format.html { redirect_to industries_url, notice: 'Industry was successfully destroyed.' }
       format.json { head :no_content }
      end
    else
      redirect_to industry_path(@industry), alert: 'You must be an admin to delete an industry.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.find(params[:id])
    end

    def set_tab
      @tab = "Industries"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industry_params
      params.require(:industry).permit(:name)
    end
end
