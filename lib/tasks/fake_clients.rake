namespace :fake do
  desc "Generate a bunch of fake clients"
  task clients: :environment do
    @user = User.first
    Client.destroy_all
    Contact.destroy_all
    (1..500).each do |i|
      puts i
      client = Client.create!(:name => Faker::Company.name,:city => Faker::Address.city, :state => Faker::Address.state, :status => "Active")
      contact = Contact.create(:name => Faker::Name.name, :email => Faker::Internet.email)
      client.contacts << contact
      client.users << @user
    end
    puts "Done!"
  end
end

#  id                   :integer          not null, primary key
#  name                 :string(255)
#  title                :string(255)
#  email                :string(255)
#  work_phone           :string(255)
#  mobile_phone         :string(255)
#  client_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  contact_description  :string(255)
#  work_phone_extension :string(255)
#  comments             :text