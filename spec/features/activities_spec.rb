require "rails_helper"

describe "create" do
  before :each do
    User.destroy_all
    Profile.destroy_all
    Contact.destroy_all
    Activity.destroy_all
  end
  it "should allow creation of an activity", :js => true do
    @user = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client.users << @user
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    visit activities_path
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Activity"
    page.should have_content "New activity"
    select "SGA (Hillsborough, NJ)", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    find_field('City').value.should eq 'Hillsborough'
    find(:css, 'select#activity_state').value.should == 'NJ'
    click_button "Save"
    page.should have_content "Activity was successfully created."
  end
  it "should allow creation of an activity on client with no contacts" do
    @user = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client.users << @user
    visit activities_path
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Activity"
    page.should have_content "New activity"
    select "SGA", :from => "Client"
    click_button "Save"
    page.should have_content "Activity was successfully created."
    #<Client id: 222, name: "0", street1: ",\",\",+1 john.blackburn@alcoa.com\"", street2: nil, city: nil, state: nil, zip: nil, phone: nil, industry: nil, created_at: "2015-06-22 22:18:11", updated_at: "2015-10-30 14:15:30", fax: nil, street3: nil, client_type: "Client">

  end
  it "should allow dynamic creation of a contact for a client" do
    User.destroy_all
    Profile.destroy_all
    Activity.destroy_all
    Contact.destroy_all
    @user = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client.users << @user
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    visit activities_path
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Activity"
    page.should have_content "New activity"
    select "SGA", :from => "Client"
    page.should have_content "or enter a new contact"
    fill_in "new_contact", :with => "Jim Knight"
    click_button "Save"
    @new_contact = Contact.find_by_name("Jim Knight")
    @client.contacts.should include(@new_contact)
  end
  it "should allow the user to only see clients assigned to them" do
    User.destroy_all
    Profile.destroy_all
    Activity.destroy_all
    Contact.destroy_all
    @user = User.create!(:email => "user1@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client_user_can_see = Client.create!(:name => "YouSeeMe", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client_user_cannot_see = Client.create!(:name => "YouDoNotSeeMe", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client_user_can_see.users << @user
    visit activities_path
    fill_in "Email", :with => "user1@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Activity"
    find_field('activity_client_id').should have_content('YouSeeMe')
    find_field('activity_client_id').should_not have_content('YouDoNotSeeMe')
  end
end

describe "index" do
  it "should allow the admins to view the activities of other people", :js => true do
    Client.destroy_all
    Contact.destroy_all
    Activity.destroy_all
    @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @client.users << @user
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    visit activities_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link "New Activity"
    page.should have_content "New activity"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    click_button "Save"
    click_link Date.today.strftime("%Y-%m-%d")
    click_link "Logout"
    visit activities_path
    fill_in "Email", :with => "admin@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    click_link Date.today.strftime("%Y-%m-%d")
    page.should have_content "Wayne Scarano"
  end
end

describe "user" do
  before :each do
    User.destroy_all
    Profile.destroy_all
  end
  it "of marketing can't see any activities" do
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :role => "Marketing")
    visit activities_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "Activities"
    page.should_not have_content "Activities"
    page.should have_content "Not authorized"
  end
  it "of marketing can't see any appointments" do
    @user = User.create!(:email => "user@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :role => "Marketing")
    visit appointments_path
    fill_in "Email", :with => "user@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should_not have_link "Appointments"
    page.should_not have_content "Listing appointments"
    page.should have_content "Not authorized"
  end
  it "can only see his created activities in the index", :js => true do
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @wayne = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @jim = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client.users << @wayne
    @client.users << @jim
    visit new_activity_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    fill_in "Comments", :with => "i am wayne"
    click_button "Save"
    click_link "Logout"
    visit new_activity_path
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Choose a contact"
    fill_in "Comments", :with => "i am jim"
    click_button "Save"
    visit activities_path
    page.should have_content "i am jim"
    page.should_not have_content "i am wayne"
  end
  it "can only open his activity" do
    @owner = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @other_user = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @activity = Activity.create!(:contact_id => @contact.id,:client_id => @client.id)
    @owner.activities << @activity
    visit activity_path @activity
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Not authorized"
  end
  it "can only edit his activities" do
    @owner = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @other_user = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ", :phone => "+1-908-359-4626")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @activity = Activity.create!(:contact_id => @contact.id,:client_id => @client.id)
    @owner.activities << @activity
    visit edit_activity_path @activity
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Not authorized"
  end
end
