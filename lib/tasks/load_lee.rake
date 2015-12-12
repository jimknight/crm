namespace :load_data do

  desc "Import from ACT file for Fred Reiss"
  task :import_for_lee => :environment do
    require 'area'
    require 'csv'
    require 'roo'
    xlsx = Roo::Spreadsheet.open(Rails.root.to_s + "/vendor/data/LeeZurmanContacts.xlsx")
    csv_text = xlsx.to_csv
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      client_name = row['Company']
      if client_name.present?
        puts "Importing for #{client_name}"
        client_street1 = row['Business Street']
        client_street2 = ""
        client_street3 = ""
        client_city = row['Business City']
        client_zip = row['Business Postal Code']
        client_fax = ""
        client_phone = row['Business Phone']
        contact_name = row['Full Name']
        contact_email = row['Business Mail']
        contact_first_name = ""
        contact_mobile_phone = row['Mobile Phone']
        contact_phone = row['Business Phone']
        contact_extension = row['Extension']
        if client_name.present?
          new_client = Client.find_or_create_by(:name => client_name,:city => client_city)
          if !contact_name.present? # handle the case where no contact named
            new_client.phone = contact_phone
          end
          new_client.phone = client_phone
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
            user = User.find_by_email('lzurman@mixers.com')
            new_client.users << user
          end
          if contact_name.present? && contact_name.length >= 3
            new_contact = Contact.find_or_create_by(:client_id => new_client.id, :name => contact_name)
            new_contact.email = contact_email
            new_contact.work_phone = contact_phone
            new_contact.work_phone_extension = contact_extension
            new_contact.mobile_phone = contact_mobile_phone
            if new_contact.changed?
              new_contact.save!
              new_client.contacts << new_contact
            end
          end
        end
      end
    end
  end
end