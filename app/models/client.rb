# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  street1    :string(255)
#  street2    :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  phone      :string(255)
#  industry   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Client < ActiveRecord::Base

  has_many :contacts
  has_many :activities
  validates :name, :city, :state, :phone, :presence => true
  def google_maps_address
    address = [name,street1,street2,city,state,zip].join(" ")
    return "http://maps.google.com/?q=#{ERB::Util.url_encode(address)}"
  end

end
