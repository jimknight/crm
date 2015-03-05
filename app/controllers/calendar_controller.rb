class CalendarController < ApplicationController

  def show
    @appointments = current_user.appointments
  end

end
