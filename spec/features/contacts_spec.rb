require "rails_helper"

describe "new" do
  it "should default the contact phone number to the client phone number" do
    User.destroy_all
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

describe "create" do
  before :each do
    Client.destroy_all
    Contact.destroy_all
    User.destroy_all
  end
  it "should have a comment field" do
    @client = Client.create!(:name => "SGA", :phone => "908-359-4626")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    visit client_path(@client)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Add Contact"
    fill_in "Name", :with => "Wayne Scarano"
    fill_in "Comments", :with => "We need to hire this guy"
    click_button "Save"
    click_link "Clients"
    click_link "SGA"
    click_link "Wayne Scarano"
    page.should have_content "We need to hire this guy"
  end
end

describe "show" do
  it "should have a link to the client email" do
    User.destroy_all
    @client = Client.create!(:name => "SGA", :phone => "908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano", :email => "wscarano@sga.com")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @user.clients << @client
    @client.contacts << @contact
    visit client_contact_path(@client,@contact)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "wscarano@sga.com"
  end
end