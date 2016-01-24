require 'rails_helper'

describe "Users" do
  it "who are admins can Create/Edit/Read all Activities", :js => true do
    pending "Until I figure out how to test autocomplete"
    User.destroy_all
    Activity.destroy_all
    Client.destroy_all
    Contact.destroy_all
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @wayne = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @jim = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @client.users << @wayne
    @client.users << @jim
    visit new_activity_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    fill_in "Comments", :with => "i am wayne"
    click_button "Save"
    click_link "Logout"
    visit new_activity_path
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    fill_in "Comments", :with => "i am jim"
    click_button "Save"
    click_link "Logout"
    visit new_activity_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    visit activities_path
    page.should have_content "i am jim"
    page.should have_content "i am wayne"
  end
  it "who are admins can Create/Edit/Read all Models" do
    User.destroy_all
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit new_model_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    fill_in "Name", :with => "Model1"
    click_button "Save"
    click_link "Model1"
    click_link "Edit"
    fill_in "Name", :with => "Model1Updated"
    click_button "Save"
    page.should have_link "Model1Updated"
  end
  it "who are admins can Create/Edit/Read all Industries" do
    User.destroy_all
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit new_industry_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    fill_in "Name", :with => "Industry1"
    click_button "Save"
    click_link "Industry1"
    click_link "Edit"
    fill_in "Name", :with => "Industry1Updated"
    click_button "Save"
    page.should have_link "Industry1Updated"
  end
end