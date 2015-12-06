# == Schema Information
#
# Table name: clients
#
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
#

class Client < ActiveRecord::Base

  before_save :default_values
  has_many :activities, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_and_belongs_to_many :users
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
    if self.city.present? && self.state.present?
      return [self.city,self.state].join(",")
    elsif !self.state.present? && self.city.present?
      return self.city
    else
      return "no location defined"
    end
  end

  def default_values
    self.client_type ||= 'Client'
    self.status ||= 'Active'
  end

  def self.unassigned_prospects
    self.where(client_type:'Prospect').includes(:users).where(users:{id: nil})
  end

end
