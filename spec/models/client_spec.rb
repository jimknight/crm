# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  street1         :string(255)
#  street2         :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  phone           :string(255)
#  industry        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  fax             :string(255)
#  street3         :string(255)
#  client_type     :string(255)
#  status          :text
#  eid             :string(255)
#  prospect_type   :text
#  source          :text
#  form_dump       :text
#  import_datetime :datetime
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
