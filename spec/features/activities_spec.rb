require "rails_helper"

describe "create" do
  it "should allow creation of an activity", :js => true do
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