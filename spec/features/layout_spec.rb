require "rails_helper"

describe "login" do
  it "should not show the upper navigation if user isn't logged in" do
    visit root_path
    page.should_not have_link "Appointments"
    page.should_not have_link "Logout"
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Appointments"
    page.should have_link "Logout"
  end
end