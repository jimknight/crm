# == Schema Information
#
# Table name: outsiders
#
#  id         :integer          not null, primary key
#  email      :string
#  first_name :string
#  last_name  :string
#  created_at :datetime
#  updated_at :datetime
#

class Outsider < ActiveRecord::Base

  has_and_belongs_to_many :clients
  validates :email, :presence => true
  validates :email, :email => true

end
