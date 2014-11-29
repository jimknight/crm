require "rails_helper"

describe "show" do
  it "should allow creation of a contact" do
    visit new_user_registration_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    fill_in "Password confirmation", :with => "ilovesga"
    click_button "Sign up"
    click_link "Clients"
    click_link "New Client"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Create Client"
    click_link "Add contact"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Create Contact"
    click_link "Wayne Scarano"
  end
end