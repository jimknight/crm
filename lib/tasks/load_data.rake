namespace :load_data do
  desc"Load all the model data"
  task :models => :environment do
    models_data ="42A","42B","42C","42N","42P","CAN","CDA","DCB","DIS","DPM","HED","HSM","KNE","LSK","MOT.LS","PART","PDM","SRVC","TE3","VCB","VMC","VS"
    models_data.each do |model|
      puts "Loading #{model}"
      Model.find_or_create_by(:name => model)
    end
    puts "Done"
  end

  desc"Load all the industry data"
  task :industries => :environment do
    industries_data = "Abrasives","Adhesives","Aerospace","Agriculture","Asphalt","Battery","Ceramics","Chemical","Coating","Composites","Cosmetics","Dealer","Demo","Dental","Electronics","Environmental","Explosives","Fab","Food","Ink","Metals","Miscellaneous","Paper","Parts orders only","PCP","Pharmaceutical","Pigments","Plaster","Plastics","Propellant","Resale","R&D","Unknown","Parts"
    industries_data.each do |industry|
      puts "Loading #{industry}"
      Industry.find_or_create_by(:name => industry)
    end
    puts "Done"
  end

  desc "Load all the clients"
  task :clients => :environment do
    require 'csv'
    csv_text = File.read(Rails.root + "vendor/data/client-contacts-loader.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      @client = Client.find_or_create_by(:name => row["Client"])
      if row["City"].present?
        @client.city = row["City"]
        @client.save!
      end
      if row["State"].present?
        @client.state = row["State"]
        @client.save!
      end
      if row["Contact"].present?
        @contact = @client.contacts.find_or_create_by(:name => row["Contact"])
        if row["Contact Description"].present?
          @contact.contact_description = row["Contact Description"]
          @contact.save!
        end
      end
    end
  end
end