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
end
