require "rails_helper"

describe "new" do
  before :each do
    User.destroy_all
    Client.destroy_all
  end
  it "should allow marketing or admin to create new prospects" do
    @marketing = User.create!(:email => "marketing@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :role => "Marketing")
    visit prospects_path
    fill_in "Email", :with => "marketing@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Prospect"
    page.should have_content "New prospect"
  end
  it "should disallow anyone other than marketing or admin to create prospects" do
    @marketing = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    visit prospects_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "New Prospect"
    visit new_prospect_path
    save_and_open_page
    page.should have_content "Not authorized"
  end
end

describe "create" do
  it "should allow marketing or admin to create new prospects (and save them)" do
    @marketing = User.create!(:email => "marketing@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :role => "Marketing")
    visit prospects_path
    fill_in "Email", :with => "marketing@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Prospect"
    page.should have_content "New prospect"
    fill_in "Name", :with => "LavaTech"
    click_button "Save"
    page.should have_content "Prospect was successfully created."
  end
end

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