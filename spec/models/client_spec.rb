# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string
#  street1         :string
#  street2         :string
#  city            :string
#  state           :string
#  zip             :string
#  phone           :string
#  industry        :string
#  created_at      :datetime
#  updated_at      :datetime
#  fax             :string
#  street3         :string
#  client_type     :string
#  status          :text
#  eid             :string
#  prospect_type   :text
#  source          :text
#  form_dump       :text
#  import_datetime :datetime
#  comments        :text
#  country         :string
#

require 'rails_helper'

RSpec.describe Client, :type => :model do
  it "should belong to multiple reps" do
    @client = Client.create!(:name => "SGA")
    @client.users.should == []
    @rep = User.create(:email => "rep@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
    @client.users << @rep
    @client.users.should == [@rep]
  end
  describe "as_csv" do
    it "should bring in the data for contacts associated" do
      @client = Client.create!(:name => "SGA")
      @rep = User.create(:email => "rep@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga")
      @client.users << @rep
      @contact1 = Contact.new(name: "Wayne Scarano", email: "wscarano@sga.com")
      @contact2 = Contact.new(name: "Jim Knight", email: "jim@sga.com")
      @client.contacts = [@contact1, @contact2]
      puts Client.all.as_csv
      Client.all.as_csv.should =~ /jim@sga.com,wscarano@sga.com/
    end
  end
  describe "import from json" do
    before :each do
      @valid_json = File.read("#{Rails.root}/spec/support/factories/prospects_valid_sample.json")
      @invalid_json = File.read("#{Rails.root}/spec/support/factories/prospects_invalid_sample.json")
      @russian_json = File.read("#{Rails.root}/spec/support/factories/prospects_russian.json")
    end
    it "should alert when json invalid" do
      FactoryGirl.create(:setting)
      Client.valid_json?(@invalid_json).should == false
      Client.import_prospects_via_json(@invalid_json)
      sent_email = ActionMailer::Base.deliveries.last
      sent_email.subject.should == "The latest prospect import data has invalid JSON"
      sent_email.to.first.should == "wscarano@sga.com"
      sent_email.parts.first.body.raw_source.should include("ARDEC")
    end
    it "should alert when fails on json" do
      FactoryGirl.create(:setting)
      Client.import_prospects_via_json(@russian_json)
      sent_email = ActionMailer::Base.deliveries.last
      sent_email.subject.should == "The latest prospect import data caused a Encoding::UndefinedConversionError"
      sent_email.to.first.should == "wscarano@sga.com"
    end
    it "should not alert when valid json and should import the data" do
      ActionMailer::Base.deliveries = []
      Client.valid_json?(@valid_json).should == true
      Client.import_prospects_via_json(@valid_json)
      ActionMailer::Base.deliveries.should == []
      Client.find_by_name("ARDEC / US Army").should_not == nil
    end
  end
  describe "create" do
    it "should remove any spaces off the end of the client name when saving or creating" do
      name_without_spaces = "SGA"
      name_with_spaces = "SGA "
      client1 = Client.create(name: name_without_spaces)
      client2 = Client.create(name: name_with_spaces)
      client1.name.should == client2.name
      client1.client_type.should == "Client"
    end
  end
end
