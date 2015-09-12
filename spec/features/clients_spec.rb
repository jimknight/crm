require "rails_helper"

describe "show" do
  it "should only show clients to specific reps (rsm's) and admins" do
    @client = Client.create!(:name => "SGA")
    @user1 = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user2 = User.create!(:email => "user2@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user2.clients << @client
    visit client_path(@client)
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Unauthorized. Only admins and RSM's connected to this client can see this client"
    click_link "Logout"
    visit client_path(@client)
    fill_in "Email", :with => "user2@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "SGA"
  end
  it "should allow creation of an activity from a client" do
    @client = Client.create!(:name => "SGA")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client.users << @user
    visit client_path(@client)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Add Activity"
  end
  it "should allow creation of a contact" do
    User.destroy_all
    @jim = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    visit new_activity_path
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Clients"
    click_link "New Client"
    fill_in "Name", :with => "Wayne Scarano"
    fill_in "City", :with => "Hillsborough"
    select "New Jersey", :from => "State"
    fill_in "Phone", :with => "+1-908-359-4626"
    click_button "Save"
    click_link "Add Contact"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Save"
    click_link "Wayne Scarano"
  end
  it "should allow someone to add an RSM to a client" do
    @client = Client.create!(:name => "SGA")
    @user1 = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user2 = User.create!(:email => "user2@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user1.clients << @client
    visit client_path(@client)
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Add RSM"
  end
  it "should show reps(rsm's) associated" do
    @rep_for_client = User.create!(:email => "rep_for_client@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @rep_wo_client = User.create!(:email => "rep_wo_client@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client_reps = Client.create!(:name => "YesReps")
    @client_reps.users << @rep_for_client
    visit client_path(@client_reps)
    fill_in "Email", :with => "rep_for_client@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content @rep_for_client.user_name
  end
end
describe "index" do
  before :each do
    User.destroy_all
  end
  it "should show a search box for clients and find the matching" do
    @client1 = Client.create!(:name => "SGA")
    @client2 = Client.create!(:name => "LavaTech")
    @user = User.create!(:email => "rep@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << [@client1,@client2]
    visit clients_path
    fill_in "Email", :with => "rep@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    fill_in "search", :with => "lava"
    click_button "Search"
    page.should have_link "LavaTech"
    page.should_not have_link "SGA"
  end
  it "should only show clients to specific reps (rsm's) and admins" do
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @user = User.create!(:email => "rep@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client_no_rep = Client.create!(:name => "NoReps")
    @client_reps = Client.create!(:name => "YesReps")
    @client_reps.users << @user
    visit clients_path
    fill_in "Email", :with => "rep@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "YesReps"
    page.should_not have_link "NoReps"
    click_link "Logout"
    visit clients_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "YesReps"
    page.should have_link "NoReps"
  end
end