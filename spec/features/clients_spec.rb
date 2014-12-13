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
    click_button "Save"
    click_link "Add Contact"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Save"
    click_link "Wayne Scarano"
  end
end