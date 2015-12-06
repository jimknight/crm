class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  def show
    if params[:prospect_id].present?
      @client = Client.find(params[:prospect_id])
    else
      @client = Client.find(params[:client_id])
    end
  end

  # GET /contacts/new
  def new
    if params[:prospect_id].present?
      @client = Client.find(params[:prospect_id])
      @tab = "Prospect"
    else
      @client = Client.find(params[:client_id])
    end
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @contact = Contact.new(contact_params)
    if @contact.save
      @client.contacts << @contact
      if @client.client_type == "Prospect"
        UserMailer.notify_new_prospect_contact(@contact,current_user).deliver # email alert
        redirect_to prospect_path(@client), notice: 'Contact was successfully created.'
      else
        redirect_to @client, notice: 'Contact was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def set_tab
      @tab = "Client"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :title, :email, :work_phone, :work_phone_extension, :mobile_phone, :client_id)
    end
end
