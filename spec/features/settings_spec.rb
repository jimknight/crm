require "rails_helper"

describe "create" do
  before :each do
    User.destroy_all
    Setting.destroy_all
  end
  it "should allow admins to create 1 settings document" do
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit root_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Settings"
    fill_in "setting_notify_on_new_prospect_contact", :with => "wscarano@sga.com"
    click_button "Save"
    page.should have_content "Settings were updated."
    Setting.last.notify_on_new_prospect_contact.should == "wscarano@sga.com"
  end
  it "should allow admins to update the only settings document without creating a new one" do
    @settings = Setting.create!(:notify_on_new_prospect_contact => "jknight@sga.com")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit root_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Settings"
    find_field('setting_notify_on_new_prospect_contact').value.should == "jknight@sga.com"
    fill_in "setting_notify_on_new_prospect_contact", :with => "wscarano@sga.com"
    click_button "Save"
    page.should have_content "Settings were updated."
    Setting.last.notify_on_new_prospect_contact.should == "wscarano@sga.com"
    Setting.count.should == 1
  end
  it "should disallow anyone but an admin to create or update the settings" do
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    visit new_setting_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Not authorized"
  end
end