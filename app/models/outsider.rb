# == Schema Information
#
# Table name: outsiders
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Outsider < ActiveRecord::Base

  has_and_belongs_to_many :clients
  validates :email, :presence => true
  validates :email, :email => true

end
