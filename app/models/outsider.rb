# == Schema Information
#
# Table name: outsiders
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  client_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Outsider < ActiveRecord::Base

  belongs_to :client
  validates :email, :presence => true

end
