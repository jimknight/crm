require "rails_helper"

describe "index" do
  it "should show the latest audit logs to an administrator" do
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    visit auditlogs_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Not authorized"
    click_link "Logout"
    visit auditlogs_path
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Logged in"
    page.should have_content "Logged out"
    page.should have_content "user@sga.com"
    page.should have_content "admin@sga.com"
  end

  describe "navigator" do
    it "should only show the link for audit logs to the admin" do
      @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
      visit clients_path
      fill_in "Email", :with => "user@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should_not have_link "Audit Logs"
      click_link "Logout"
      visit root_path
      @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should have_link "Audit Logs"
    end
  end
end
