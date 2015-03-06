class CalendarController < ApplicationController

  before_action :set_tab

  def show
    @appointments = current_user.appointments
  end

  def set_tab
    @tab = "Appointments"
  end

end
