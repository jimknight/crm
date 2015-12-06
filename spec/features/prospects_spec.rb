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
    page.should have_content "Not authorized"
  end
end

describe "create" do
  before :each do
    Client.destroy_all
    User.destroy_all
  end
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
    page.should have_link "LavaTech"
  end
  it "should have a comment field" do
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @marketing = User.create!(:email => "marketing@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :role => "Marketing")
    visit prospects_path
    fill_in "Email", :with => "marketing@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Prospect"
    fill_in "Name", :with => "SGA"
    fill_in "Comments", :with => "We need to hire these guys"
    click_button "Save"
    click_link "Logout"
    visit prospects_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "SGA"
    page.should have_content "We need to hire these guys"
  end
end

describe "index" do
  before :each do
    User.destroy_all
    Client.destroy_all
  end
  it "should open the prospect not the client when clicking the link" do
    @prospect = Client.create!(:name => "SGA",:client_type => "Prospect")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @prospect.contacts << @contact
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit prospect_path(@prospect)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    visit prospects_path
    click_link "SGA"
    page.should have_content "Contacts for this prospect"
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

describe "show" do
  before :each do
    User.destroy_all
    Profile.destroy_all
  end
  it "should not allow a user to see administrators within the list of RSM's to assign" do
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @prospect = Client.create!(:name => "LavaTech",:client_type => "Prospect")
    visit prospect_path(@prospect)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Add RSM"
    page.should_not have_content "admin@sga.com"
    page.should have_content "user@sga.com"
  end
  it "should allow an admin to click a button to change to a normal client" do
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @prospect = Client.create!(:name => "LavaTech",:client_type => "Prospect")
    visit prospect_path(@prospect)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "Convert to Client"
    click_link "Logout"
    visit prospect_path(@prospect)
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Convert to Client"
    page.should have_content "Converted this prospect to an active client"
  end
end

describe "contact" do
  before :each do
    User.destroy_all
    Client.destroy_all
  end
  it "should show the prospect page after creating a new contact for a prospect" do
    @client = Client.create!(:name => "SGA",:client_type => "Prospect")
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    visit client_path(@client)
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "Add Contact"
    fill_in "Name", :with => "Wayne Scarano"
    click_button "Save"
    page.should have_content "Contacts for this prospect"
  end
end