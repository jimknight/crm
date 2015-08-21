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