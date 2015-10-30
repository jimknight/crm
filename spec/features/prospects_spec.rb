require "rails_helper"

describe "index" do
  before :each do
    User.destroy_all
    Client.destroy_all
  end
  it "should show a link to the prospects page in the root" do
    @client1 = Client.create!(:name => "SGA")
    @client2 = Client.create!(:name => "LavaTech",:client_type => "Prospect")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit root_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "Prospects"
    click_link "Prospects"
    page.should have_link "LavaTech"
  end
  it "should show only prospects when visiting the prospects page" do
    @client1 = Client.create!(:name => "SGA")
    @client2 = Client.create!(:name => "LavaTech",:client_type => "Prospect")
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit prospects_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_link "LavaTech"
    page.should_not have_link "SGA"
  end
end