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

#  id         :integer          not null, primary key
#  title      :string(255)
#  client_id  :integer
#  user_id    :integer
#  start_time :datetime
#  end_time   :datetime
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#  start_date :date
#  end_date   :date
#