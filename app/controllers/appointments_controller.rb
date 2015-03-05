class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def by_date
    # TODO: put in order
    @search_date = Date.strptime(params["appt_date"], '%Y-%m-%d')
    @appointments = current_user.appointments.where("start_time > ?", @search_date.beginning_of_day).where("start_time < ?", @search_date.end_of_day)
  end

  def index
    @appointments = current_user.appointments
      respond_with do |format|
      format.html {
        respond_with @appointments
      }
      format.json {
        events = {}
        @appointments.each do |appt|
          appt_url = { "url" => "/appointments/by-date/#{appt.pretty_calendar_date}" }
          events[appt.pretty_calendar_date] = appt_url
        end
        render :json => events
      }
    end
  end

  def show
    respond_with(@appointment)
  end

  def new
    @appointment = Appointment.new
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    @appointment.start_time = Time.strptime(appointment_params["start_time"], "%m/%d/%Y %I:%M %P")
    @appointment.end_time = Time.strptime(appointment_params["end_time"], "%m/%d/%Y %I:%M %P")
    if @appointment.save
      redirect_to appointments_path, :notice => "Appointment saved!"
    else
      render :new
    end
  end

  def update
    @appointment.update(appointment_params)
    respond_with(@appointment)
  end

  def destroy
    @appointment.destroy
    respond_with(@appointment)
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:title, :client_id, :user_id, :start_time, :end_time, :comments)
    end
end
