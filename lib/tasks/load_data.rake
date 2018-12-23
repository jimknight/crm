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

  desc "Import from ACT file"
  task :import_clients_contacts_from_act_spreadsheet => :environment do
    require 'area'
    require 'csv'
    require 'roo'
    xlsx = Roo::Spreadsheet.open(Rails.root.to_s + "/vendor/data/Act exported Contacts.xlsx")
    csv_text = xlsx.to_csv
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      client_name = row['Company']
      puts "Importing for #{client_name}"
      client_street1 = row['Address 1']
      client_street2 = row['Address 2']
      client_street3 = row['Address 3']
      client_city = row['City']
      client_zip = row['Zip']
      client_fax = row['Fax']
      contact_name = row['Contact']
      contact_email = row['E-mail']
      contact_first_name = row['First Name']
      contact_mobile_phone = row['Mobile Phone']
      contact_phone = row['Phone']
      if client_name.present?
        new_client = Client.find_or_create_by(:name => client_name,:city => client_city)
        if !contact_name.present? # handle the case where no contact named
          new_client.phone = contact_phone
        end
        new_client.fax = client_fax
        new_client.street1 = client_street1
        new_client.street2 = client_street2
        new_client.street3 = client_street3
        if client_zip.present?
          begin
          new_client.state = client_zip.split("-")[0].to_region(:state => true)
          rescue
            # don't bother
          end
          new_client.zip = client_zip
        end
        if new_client.changed?
          new_client.save!
        end
        if contact_name.present? && contact_name.length >= 3
          new_contact = Contact.find_or_create_by(:client_id => new_client.id, :name => contact_name)
          new_contact.email = contact_email
          new_contact.work_phone = contact_phone
          new_contact.mobile_phone = contact_mobile_phone
          if new_contact.changed?
            new_contact.save!
            new_client.contacts << new_contact
          end
        end
      end
    end
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

  desc "Backfill clients loaded from old system and saved as csv"
  task :clients_from_csv => :environment do
    file_path = "clients.csv"
    CSV.foreach(file_path, :headers => true) do |row|
      id = row["id"]
      name = row["name"]
      street1 = row["street1"]
      street2 = row["street2"]
      city = row["city"]
      state = row["state"]
      zip = row["zip"]
      phone = row["phone"]
      industry = row["industry"]
      created_at = row["created_at"]
      updated_at = row["updated_at"]
      fax = row["fax"]
      street3 = row["street3"]
      client_type = row["client_type"]
      status = row["status"]
      eid = row["eid"]
      prospect_type = row["prospect_type"]
      source = row["source"]
      form_dump = row["form_dump"]
      import_datetime = row["import_datetime"]
      comments = row["comments"]
      country = row["country"]
      puts "EID = #{eid}"
        existing_client = Client.find_by_eid(eid)
        if existing_client.nil?
        end
    end
  end

  desc "Backfill contacts loaded from old system and saved as csv"
  task :contacts_from_csv => :environment do
    file_path = "contacts.csv"
    CSV.foreach(file_path, :headers => true) do |row|
      id = row["id"]
      name = row["name"]
      title = row["title"]
      email = row["email"]
      work_phone = row["work_phone"]
      mobile_phone = row["mobile_phone"]
      client_id = row["client_id"]
      created_at = row["created_at"]
      updated_at = row["updated_at"]
      contact_description = row["contact_description"]
      work_phone_extension = row["work_phone_extension"]
      comments = row["comments"]
      contact_params = {name: name, title: title, email: email, work_phone: work_phone, mobile_phone: mobile_phone, contact_description: contact_description, work_phone_extension: work_phone_extension}
      puts "Importing name: #{name} with email: #{email}"
      Contact.create_from_import(contact_params)
    end
  end
end

#
#
#

# id	name	street1	street2	city	state	zip	phone	industry
# created_at	updated_at	fax	street3	client_type	status	eid	prospect_type	source
# form_dump	import_datetime	comments	country
