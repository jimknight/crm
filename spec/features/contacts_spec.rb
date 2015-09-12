require "rails_helper"

describe "new" do
  it "should default the contact phone number to the client phone number" do
    @client = Client.create!(:name => "SGA", :phone => "908-359-4626")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    visit client_path(@client)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Add Contact"
    find_field('Work phone').value.should eq '908-359-4626'
  end
end