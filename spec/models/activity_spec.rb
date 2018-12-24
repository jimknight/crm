require 'rails_helper'

RSpec.describe Activity, :type => :model do
  describe "create_from_import" do

    it "should correctly save the activity date" do
      client = create(:client)
      activity_date_string = "2018-12-03 00:00:00 -0500"
      activity_params = {client_id: client.id, activity_date: Date.parse(activity_date_string)}
      activity = Activity.create_from_import(activity_params)
      activity.activity_date.should == Date.new(2018,12,3).in_time_zone("Eastern Time (US & Canada)")
    end

    it "shouldn't create a duplicate activity if one already exists" do
      client = create(:client)
      activity_date_string = "2018-12-03 00:00:00 -0500"
      activity_params = {client_id: client.id, activity_date: Date.parse(activity_date_string)}
      Activity.create_from_import(activity_params)
      Activity.create_from_import(activity_params)
      Activity.all.count.should == 1
    end
  end
end
