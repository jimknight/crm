require "rails_helper"

describe "index" do
  it "should only allow admins to create new models" do
    User.destroy_all
    Model.destroy_all
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga",:admin => true)
    @model = Model.create!(:name => "42A")
    visit models_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "New Model"
    click_link "Logout"
    visit models_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "New Model"
  end
end
describe "show" do
  before(:each) do
    User.destroy_all
    Model.destroy_all
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga",:admin => true)
    @model = Model.create!(:name => "42A")
  end
  it "should only show activities for this model to activity owners or admins" do
    @user_who_cannot_see_activities = User.create!(:email => "usercannot@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @activity = Activity.create!(:contact_id => @contact.id,:client_id => @client.id,:user_id => @user.id)
    @activity.models << @model
    visit model_path(@model)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "SGA"
    click_link "Logout"
    visit model_path(@model)
    fill_in "Email", :with => "usercannot@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "SGA"
    click_link "Logout"
    visit model_path(@model)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "SGA"
  end
  it "should only allow admins to edit a model" do
    visit model_path(@model)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "Edit"
    click_link "Logout"
    visit model_path(@model)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Edit"
  end
end