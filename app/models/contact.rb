# == Schema Information
#
# Table name: contacts
#
#  id                   :integer          not null, primary key
#  name                 :string
#  title                :string
#  email                :string
#  work_phone           :string
#  mobile_phone         :string
#  client_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  contact_description  :string
#  work_phone_extension :string
#  comments             :text
#

class Contact < ActiveRecord::Base
  belongs_to :client
  validates :name, :presence => true

  # Simple avoid duplicates on import from leads - not case sensitive
  def self.create_from_import(contact_params)
    trimmed_params = contact_params.each { |k, v| contact_params[k] = v.nil? ? v : v.gsub("\t","").strip }
    existing_contact = Contact.find_by(name: trimmed_params[:name], email: trimmed_params[:email])
    if existing_contact.nil?
      Contact.create(trimmed_params)
    else
      existing_contact
    end
  end

  def pretty_work_phone_extension
    if self.work_phone_extension.downcase.include?("x")
      return self.work_phone_extension
    else
      return "x#{self.work_phone_extension}"
    end
  end

  def self.as_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
end
