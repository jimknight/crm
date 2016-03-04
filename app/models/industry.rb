# == Schema Information
#
# Table name: industries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Industry < ActiveRecord::Base
  validates :name, :presence => true
end
