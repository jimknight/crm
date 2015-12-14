require "rails_helper"

describe "by_date" do
  it "should link to the appointment not the client" do
    User.destroy_all
    Client.destroy_all
    Appointment.destroy_all
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

describe "show" do
  it "should allow the user to delete the appointment" do
    User.destroy_all
    Client.destroy_all
    Appointment.destroy_all
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
    User.destroy_all
    Client.destroy_all
    Appointment.destroy_all
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