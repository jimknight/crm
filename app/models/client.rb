# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string
#  street1         :string
#  street2         :string
#  city            :string
#  state           :string
#  zip             :string
#  phone           :string
#  industry        :string
#  created_at      :datetime
#  updated_at      :datetime
#  fax             :string
#  street3         :string
#  client_type     :string
#  status          :text
#  eid             :string
#  prospect_type   :text
#  source          :text
#  form_dump       :text
#  import_datetime :datetime
#  comments        :text
#  country         :string
#

class Client < ActiveRecord::Base

  before_save :default_values, :trim_spaces_from_name
  has_many :activities, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :outsiders
  validates :name, :presence => true

  def archived?
    if self.status == "Archived"
      return true
    else
      return false
    end
  end

  def google_maps_address
    if street1.present?
      address = [name,street1,street2,city,state,zip].join(" ")
      return "http://maps.google.com/?q=#{ERB::Util.url_encode(address)}"
    else
      return ""
    end
  end

  def location
    if self.city.present? && self.state.present? && self.country.present?
      return [self.city,self.state].join(", ") + " (#{self.country})"
    elsif self.city.present? && self.state.present?
      return [self.city,self.state].join(", ")
    elsif !self.state.present? && self.city.present?
      return self.city
    else
      return "no location defined"
    end
  end

  def name_and_location
    location = self.location
    if location == "no location defined"
      return name
    else
      return "#{name} (#{location})"
    end
  end

  def default_values
    self.client_type ||= 'Client'
    self.status ||= 'Active'
  end

  def trim_spaces_from_name
    self.name = self.name.strip
  end

  def self.as_csv
    CSV.generate do |csv|
      x = column_names + ["contacts_email", "users_email"]
      csv << x
      all.each do |item|
        y = item.attributes.values_at(*column_names) + [item.contacts.pluck("email").join(",")] + [item.users.pluck("email").join(",")]
        csv << y
      end
    end
  end

  def self.unassigned_prospects
    self.where(client_type:'Prospect').where(status:'Active').includes(:users).where(users:{id: nil}).includes(:outsiders).where(outsiders:{id: nil})
  end

  def self.assigned_prospects_to_rsms
    self.where(client_type:'Prospect').where(status:'Active').includes(:users).where.not(users:{id: nil})
  end

  def self.assigned_prospects_to_outsiders
    self.where(client_type:'Prospect').where(status:'Active').includes(:outsiders).where.not(outsiders:{id: nil})
  end

  def self.import_prospects_via_json(json)
    if valid_json?(json)
      parsed_response = JSON.parse(json)
      parsed_response.each do |data|
        import_eid = data["EID"]
        import_date = data["Date"]
        import_type = data["Type"]
        import_source = data["Source"]
        import_company = data["Company"].force_encoding('Windows-1252').encode('UTF-8')
        import_contactname = data["ContactName"].force_encoding('Windows-1252').encode('UTF-8')
        import_phone = data["Phone"]
        import_fax = data["Fax"]
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
              :status => "Active",
              :fax => import_fax
            )
            contact_params = {name: import_contactname, work_phone: import_phone, email: import_email}
            new_contact = Contact.create_from_import(contact_params)
            new_client.contacts << new_contact
            puts "Imported #{new_client.name}"
          else
            puts "Skipping EID = #{import_eid} for client #{import_company}. Already in DB by EID"
          end
        else
          puts "Skipping EID = #{import_eid} for client #{import_company}. Import date of #{import_date} is too old."
        end
        rescue Encoding::UndefinedConversionError
          UserMailer.notify_on_encoding_error_during_import(json).deliver_now
          next
      end
    else
      UserMailer.notify_on_invalid_json(json).deliver_now
    end
  end

  def self.valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError
    return false
  end
end
