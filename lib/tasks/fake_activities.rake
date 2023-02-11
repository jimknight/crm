namespace :fake do
  desc "Generate a bunch of fake activities"
  task activities: :environment do
    @user = User.first
    @client = Client.last
    (1..10000).each do |i|
      puts i
      activity = Activity.create!(:client_id => @client.id,:user_id => @user.id,:activity_date => Time.now)
    end
    puts "Done!"
  end
end

#  id            :integer          not null, primary key
#  client_id     :integer
#  activity_date :datetime
#  contact_id    :integer
#  city          :string(255)
#  state         :string(255)
#  industry      :string(255)
#  comments      :text
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  attachment    :string(255)
