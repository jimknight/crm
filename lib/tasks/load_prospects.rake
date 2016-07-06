namespace :load_data do

  desc "Pull data from API returning JSON"
  task :prospects => :environment do
    require 'net/http'
    url = 'http://leads.mixers.com/data/mainLeads.asp'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    Client.import_prospects_via_json(response)
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
