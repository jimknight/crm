require "rails_helper"

describe "by_date" do
  it "should link to the appointment not the client" do
    @client = Client.create!(:name => "SGA")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    @appointment = Appointment.create!(:user_id => @user.id, :title => "Meeting with POTUS", :client_id => @client.id, :start_time => Time.now, :end_time => 1.hours.from_now, :start_date => Date.today, :end_date => Date.today)
    visit appointments_by_date_path(:appt_date => Date.today.strftime("%Y-%m-%d"))
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "SGA"
    page.should have_content "Meeting with POTUS"
  end
end

describe "new" do
  it "should show the client with city/state in the picker" do
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    visit new_appointment_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA (Hillsborough, NJ)", :from => "Client"
  end
end

describe "create" do
  before :each do
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
  end
  it "should alert when user doesn't enter a subject" do
    visit new_appointment_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA (Hillsborough, NJ)", :from => "Client"
    fill_in "appointment_start_date", :with => "2016-02-24"
    fill_in "Start time", :with => "12:00:00"
    fill_in "End time", :with => "12:40:00"
    click_button "Save"
    page.should have_content "can't be blank"
  end
  it "should show the time zone of the user" do
    visit new_appointment_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "EDT"
    @user.profile.update_attribute("time_zone","Hawaii")
    visit new_appointment_path
    page.should have_content "HST"
  end
end

describe "show" do
  it "should allow the user to delete the appointment" do
    @client = Client.create!(:name => "SGA")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    @appointment = Appointment.create!(:user_id => @user.id, :title => "Meeting with POTUS", :client_id => @client.id, :start_time => Time.now, :end_time => 1.hours.from_now, :start_date => Date.today, :end_date => Date.today)
    visit appointment_path(@appointment)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Delete"
    page.should have_content "deleted"
  end
end

describe "edit" do
  it "should allow a user to edit a saved appointment" do
    @client = Client.create!(:name => "SGA")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    @appointment = Appointment.create!(:user_id => @user.id, :title => "Meeting with POTUS", :client_id => @client.id, :start_time => Time.now, :end_time => 1.hours.from_now, :start_date => Date.today, :end_date => Date.today)
    visit appointment_path(@appointment)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Edit"
    page.should have_content "Edit"
  end
end
