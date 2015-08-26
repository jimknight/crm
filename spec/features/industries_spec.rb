require "rails_helper"

describe "index" do
  it "should only allow admins to create an industry" do
    User.destroy_all
    Industry.destroy_all
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga",:admin => true)
    @industry = Industry.create!(:name => "CyberSecurity")
    visit industries_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "New Industry"
    click_link "Logout"
    visit industries_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "New Industry"
  end
end
describe "show" do
  it "should only allow admins to edit an industry" do
    User.destroy_all
    Industry.destroy_all
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga",:admin => true)
    @industry = Industry.create!(:name => "CyberSecurity")
    visit industry_path(@industry)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "Edit"
    click_link "Logout"
    visit industry_path(@industry)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Edit"
  end
end
