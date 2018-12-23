require 'rails_helper'

RSpec.describe Contact, :type => :model do
  it "should create a new contact given complete data" do
    name = "Theang Ngo"
    title = "Test"
    email = "theang@coalescencellc.com"
    work_phone = "614-861-3639"
    contact_description = "Plant Manager"
    contact = Contact.create(name: name, title: title, email: email, work_phone: work_phone, contact_description: contact_description)
    contact.name.should == name
    contact.contact_description.should == contact_description
  end
  it "should reject a new contact given missing data" do
    name = nil
    title = "Test"
    email = "theang@coalescencellc.com"
    Contact.create(name: name, title: title, email: email).valid?.should == false
  end
  describe "create_from_import" do
    it "should return an existing contact (matching name/email) if it exists" do
      contact1_params = {name: "Bertevello", email: "tecnico@swigroup.eu", work_phone: "041-303-6140:"}
      contact2_params = {name: "Bertevello", email: "tecnico@swigroup.eu", work_phone: "--:"}
      contact1 = Contact.create_from_import(contact1_params)
      contact2 = Contact.create_from_import(contact2_params)
      contact2.id.should == contact1.id
    end
    it "should not create a duplicate for an existing contact" do
      contact_params = {name: "Alex Sailsman", title: "Engineering", email: ""}
      contact1 = Contact.create_from_import(contact_params)
      contact2 = Contact.create_from_import(contact_params)
      Contact.all.count.should == 1
    end
    it "should trim out any \t from data when saving" do
      contact_params = {name: "Greg Masters", title: "", email: "gmasters@gaiaherbs.com  \t"}
      contact = Contact.create_from_import(contact_params)
      contact.email.should == "gmasters@gaiaherbs.com"
    end
    it "should not fail when params contain blank or nil" do
      contact_params = {name: "Darrel Jankowski", title: "", email: nil}
      contact = Contact.create_from_import(contact_params)
      contact.name.should == "Darrel Jankowski"
    end
  end
end
