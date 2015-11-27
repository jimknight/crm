namespace :load_data do

  desc "Pull data from API returning JSON"
  task :prospects => :environment do
    require 'net/http'
    url = 'http://leads.mixers.com/data/mainLeads.asp'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)
    parsed_response.each do |data|
      import_eid = data["EID"]
      import_date = data["Date"]
      import_type = data["Type"]
      import_source = data["Source"]
      import_company = data["Company"]
      import_contactname = data["ContactName"].force_encoding('Windows-1252').encode('UTF-8')
      import_phone = data["Phone"]
      import_email = data["Email"]
      import_formdump = data["FormDump"].force_encoding('Windows-1252').encode('UTF-8')
      existing_client = Client.find_by_eid(import_eid)
      if existing_client.nil? && import_company.present?
        # create a new one - assume EST
        new_client = Client.create!(
          :eid => import_eid,
          :name => import_company,
          :import_datetime => DateTime.strptime(import_date + " EST", '%Y-%m-%d %R %Z'),
          :prospect_type => import_type,
          :source => import_source,
          :form_dump => import_formdump,
          :client_type => "Prospect",
          :status => "Active"
          )
        new_contact = Contact.create!(
          :name => import_contactname,
          :work_phone => import_phone,
          :email => import_email
          )
        new_client.contacts << new_contact
        puts "Imported #{new_client.name}"
      else
        puts "Skipping EID = #{import_eid} for client #{import_company}. Already in DB by EID"
      end
    end
  end
end