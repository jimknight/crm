require "rails_helper"

describe "show" do
  it "should allow creation of a contact" do
    @client = Client.create!(:name => "SGA")
    visit client_path(@client)
    click_link "Add contact"
    page.should have_content "New contact"
  end
end