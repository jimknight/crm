require "rails_helper"

describe "create" do
  it "should allow creation of an activity" do
    @client = Client.create!(:name => "SGA")
    @contact = Contact.create!(:name => "Wayne Scarano")
    @client.contacts << @contact
    visit activities_path
    click_link "New Activity"
    page.should have_content "New activity"
  end
end