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
  before :each do
    User.destroy_all
    Industry.destroy_all
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga",:admin => true)
    @industry = Industry.create!(:name => "CyberSecurity")
  end
  it "should only show clients to user's who own the clients or admins" do
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626", :industry => @industry.id)
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @user_who_cannot_see = User.create!(:email => "usercannot@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client.users << @user
    visit industry_path(@industry)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "SGA"
    click_link "Logout"
    visit industry_path(@industry)
    fill_in "Email", :with => "usercannot@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "SGA"
  end
  it "should only allow admins to edit an industry" do
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
