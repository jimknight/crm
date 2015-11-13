# == Schema Information
#
# Table name: clients
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  street1     :string(255)
#  street2     :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  phone       :string(255)
#  industry    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  fax         :string(255)
#  street3     :string(255)
#  client_type :string(255)
#

class Client < ActiveRecord::Base

  before_save :default_values
  has_many :activities
  has_many :contacts
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
    address = [name,street1,street2,city,state,zip].join(" ")
    return "http://maps.google.com/?q=#{ERB::Util.url_encode(address)}"
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
  end

end
