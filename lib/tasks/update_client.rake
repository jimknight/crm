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

  desc "Trim spaces in clients where name has spaces"
  task :clients_with_spaces_in_name => :environment do
    clients = Client.all
    clients.each do |c|
      trimmed_name = c.name.strip
      if trimmed_name != c.name
        puts "Client #{c.name} has extra spaces. Trimming."
        c.save!
        puts "Updated #{c.name} to trimmed name"
      end
    end
    puts "Done"
  end
end
