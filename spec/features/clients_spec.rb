require "rails_helper"

describe "show" do
  it "should allow creation of a contact" do
    @client = Client.create!(:name => "SGA")
    visit new_user_registration_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    fill_in "Password confirmation", :with => "ilovesga"
    click_button "Sign up"
    visit client_path(@client)
    click_link "Add contact"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Create Contact"
    click_link "Wayne Scarano"
  end
end