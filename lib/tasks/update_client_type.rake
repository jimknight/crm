namespace :update_existing do
  desc"Update existing clients with client_type = Client"
  task :clients => :environment do
    clients = Client.where(client_type: nil)
    clients.each do |c|
      c.client_type = 'Client'
      c.save!
      puts "Updated #{c.name}"
    end
    puts "Done"
  end
end