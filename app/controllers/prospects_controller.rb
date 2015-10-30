class ProspectsController < ApplicationController

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

private

  def set_tab
    @tab = "Prospect"
  end

end
