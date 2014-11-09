# == Schema Information
#
# Table name: industries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Industry < ActiveRecord::Base
end
