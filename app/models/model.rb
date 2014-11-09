# == Schema Information
#
# Table name: models
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Model < ActiveRecord::Base
  has_and_belongs_to_many :activities
end
