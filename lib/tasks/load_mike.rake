namespace :load_data do

  # Public/Private
  # Record Manager
  # Company
  # Contact
  # Address 1
  # Address 2
  # Address 3
  # City
  # State
  # Zip
  # Country
  # ID/Status
  # Phone
  # Fax
  # Home Phone
  # Mobile Phone
  # Pager
  # Salutation
  # Last Meeting
  # Last Reach
  # Last Attempt
  # Letter Date
  # Title
  # Assistant
  # Last Results
  # Referred By
  # User 1
  # User 2
  # User 3
  # User 4
  # User 5
  # User 6
  # User 7
  # User 8
  # User 9
  # User 10
  # User 11
  # User 12
  # User 13
  # User 14
  # User 15
  # Home Address 1
  # Home Address 2
  # Home City
  # Home State
  # Home Zip
  # Home Country
  # Alt Phone
  # 2nd Contact
  # 2nd Title
  # 2nd Phone
  # 3rd Contact
  # 3rd Title
  # 3rd Phone
  # First Name
  # Last Name
  # Phone Ext.
  # Fax Ext.
  # Alt Phone Ext.
  # 2nd Phone Ext.
  # 3rd Phone Ext.
  # Asst. Title
  # Asst. Phone
  # Asst. Phone Ext.
  # Department
  # Spouse
  # Record Creator
  # Owner
  # 2nd Last Reach
  # 3rd Last Reach
  # Web Site
  # Ticker Symbol
  # County
  # New Field 1
  # Create Date
  # Edit Date
  # Merge Date
  # E-mail Login
  # E-mail System

  desc "Import from ACT file for Fred Reiss"
  task :import_for_mike => :environment do
    require 'area'
    require 'csv'
    require 'roo'
    xlsx = Roo::Spreadsheet.open(Rails.root.to_s + "/vendor/data/MikeMorseContactsAct.xlsx")
    csv_text = xlsx.to_csv
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      client_name = row['Company']
      if client_name.present?
        puts "Importing for #{client_name}"
        client_street1 = row['Address 1']
        client_street2 = row['Address 2']
        client_street3 = row['Address 3']
        client_city = row['City']
        client_state = row['State']
        client_zip = row['Zip']
        client_fax = row['Fax']
        client_phone = row['Phone']
        contact_name = row['Contact']
        contact_email = row['E-mail Login']
        contact_first_name = row['First Name']
        contact_last_name = row['Last Name']
        contact_mobile_phone = row['Mobile Phone']
        contact_phone = row['Phone']
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
          new_client.state = client_state
          new_client.city = client_city
          new_client.zip = client_zip
          if new_client.changed?
            new_client.save!
            user = User.find_by_email('mmorse@mixers.com')
            new_client.users << user
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
  end
end