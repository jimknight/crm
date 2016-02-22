# == Schema Information
#
# Table name: models
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Model < ActiveRecord::Base
  has_and_belongs_to_many :activities
  validates :name, :presence => true
end
