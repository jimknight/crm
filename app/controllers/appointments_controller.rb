class AppointmentsController < ApplicationController
  before_action :hide_from_marketing
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :set_tab

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
          if events[appt.pretty_calendar_date].nil?
            appt_url = { "url" => "/appointments/by-date/#{appt.pretty_calendar_date}", "number" => 1 }
          else
            appt_url = { "url" => "/appointments/by-date/#{appt.pretty_calendar_date}", "number" => events[appt.pretty_calendar_date]["number"] += 1 }
          end
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
    if params[:day].present?
      @selected_date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    else
      @selected_date = 0.business_day.from_now.to_date
    end
    @appointment = Appointment.new
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = Appointment.new(:client_id => appointment_params[:client_id], :title => appointment_params[:title], :comments => appointment_params[:comments])
    @appointment.user = current_user
    @appointment.start_time = ("#{appointment_params[:start_date]} #{appointment_params[:start_time]} EDT").to_datetime
    @appointment.end_time = ("#{appointment_params[:start_date]} #{appointment_params[:end_time]} EDT").to_datetime
    if @appointment.save
      redirect_to calendar_path, :notice => "Appointment saved!"
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
    def hide_from_marketing
      if current_user.marketing? && !current_user.admin?
        redirect_to prospects_path, :alert => "Not authorized. Users who are in the marketing role may not access appointments."
      end
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def set_tab
      @tab = "Appointments"
    end

    def appointment_params
      params.require(:appointment).permit(:title, :client_id, :user_id, :start_date, :start_time, :end_date, :end_time, :comments)
    end
end
