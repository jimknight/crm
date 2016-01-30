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
      import_company = data["Company"].force_encoding('Windows-1252').encode('UTF-8')
      import_contactname = data["ContactName"].force_encoding('Windows-1252').encode('UTF-8')
      import_phone = data["Phone"]
      import_email = data["Email"]
      import_street = data["Address"][0]["Street"].force_encoding('Windows-1252').encode('UTF-8')
      import_city = data["Address"][0]["City"].force_encoding('Windows-1252').encode('UTF-8')
      import_state = data["Address"][0]["State"].force_encoding('Windows-1252').encode('UTF-8')
      import_country = data["Address"][0]["Country"].force_encoding('Windows-1252').encode('UTF-8')
      import_zip = data["Address"][0]["ZipCode"]
      import_formdump = data["FormDump"].force_encoding('Windows-1252').encode('UTF-8')
      existing_client = Client.find_by_eid(import_eid)
      import_datetime = DateTime.strptime(import_date + " EST", '%Y-%m-%d %R %Z')
      if import_company == "1" || import_company == "-1"
        puts "Skipping EID = #{import_eid} for client #{import_company}. Junk data"
      elsif import_datetime >= "2015-12-01".to_date
        if existing_client.nil? && import_company.present?
          # create a new one - assume EST
          new_client = Client.create!(
            :eid => import_eid,
            :name => import_company,
            :street1 => import_street,
            :city => import_city,
            :state => import_state,
            :zip => import_zip,
            :country => import_country,
            :import_datetime => import_datetime,
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
      else
        puts "Skipping EID = #{import_eid} for client #{import_company}. Import date of #{import_date} is too old."
      end
    end
  end
end

#  id              :integer          not null, primary key
#  name            :string(255)
#  street1         :string(255)
#  street2         :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  phone           :string(255)
#  industry        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  fax             :string(255)
#  street3         :string(255)
#  client_type     :string(255)
#  status          :text
#  eid             :string(255)
#  prospect_type   :text
#  source          :text
#  form_dump       :text
#  import_datetime :datetime
#  comments        :text

# {
#     "EID": "421",
#     "Date": "2015-12-05 13:40",
#     "Type": "Webinar Request",
#     "Source": "www.mixers.com",
#     "Company": "1",
#     "ContactName": "-1` 1",
#     "Address": [{
#       "Street": "",
#       "City": "1",
#       "State": "1",
#       "Country": "",
#       "ZipCode": ""
#     }],
#     "Phone": "1",
#     "Email": "1",
#     "FormDump": "Webinar Request - <BR><BR>12\/5\/2015 1:40:20 PM<BR><BR><html><body><br><b>Company Name<\/b>1<BR><BR><br><b>First Name: <\/b>-1`<BR><BR><br><b>Last Name: <\/b>1<BR><BR><br><b>City: <\/b>1<BR><BR><br><b>State: <\/b>1<BR><BR><br><b>Phone: <\/b>1<BR><BR><br><b>Email: <\/b>1<BR><BR><br><\/body><\/html>"
# }

