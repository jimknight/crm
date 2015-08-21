require "rails_helper"

describe "show" do
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
  it "should show reps(rsm's) associated" do
    @rep_for_client = User.create!(:email => "rep_for_client@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @rep_wo_client = User.create!(:email => "rep_wo_client@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client_reps = Client.create!(:name => "YesReps")
    @client_reps.users << @rep_for_client
    visit client_path(@client_reps)
    fill_in "Email", :with => "rep_wo_client@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content @rep_for_client.user_name
  end
end
describe "index" do
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