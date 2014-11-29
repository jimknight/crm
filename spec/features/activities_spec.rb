require "rails_helper"

describe "create" do
  it "should allow creation of an activity", :js => true do
    User.destroy_all
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    visit new_user_registration_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    fill_in "Password confirmation", :with => "ilovesga"
    click_button "Sign up"
    visit activities_path
    click_link "New Activity"
    page.should have_content "New activity"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Contact"
    find_field('City').value.should eq 'Hillsborough'
    find(:css, 'select#activity_state').value.should == 'NJ'
  end
end

describe "user" do
  it "can only see his created activities in the index", :js => true do
    @client = Client.create!(:name => "SGA", :city => "Hillsborough", :state => "NJ")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    @wayne = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @jim = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    visit new_activity_path
    fill_in "Email", :with => "wscarano@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Contact"
    fill_in "Comments", :with => "i am wayne"
    click_button "Save"
    click_link "Logout"
    visit new_activity_path
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    select "SGA", :from => "Client"
    select "Wayne Scarano", :from => "Contact"
    fill_in "Comments", :with => "i am jim"
    click_button "Save"
    visit activities_path
    page.should have_content "i am jim"
    page.should_not have_content "i am wayne"
    # visit activity_path Activity.first
  end
  it "can only open his activity" do
      @owner = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
      @other_user = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
      @activity = Activity.create!
      @owner.activities << @activity
      visit activity_path @activity
      fill_in "Email", :with => "jknight@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should have_content "Not authorized"
  end
  it "can only edit his activities" do
    User.destroy_all # something wrong here with db clean
    @owner = User.create!(:email => "wscarano@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @other_user = User.create!(:email => "jknight@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @activity = Activity.create!
    @owner.activities << @activity
    visit edit_activity_path @activity
    fill_in "Email", :with => "jknight@sga.com"
    fill_in "Password", :with => "ilovesga"
    click_button "Sign in"
    page.should have_content "Not authorized"
  end
end
