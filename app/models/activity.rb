# == Schema Information
#
# Table name: activities
#
#  id            :integer          not null, primary key
#  client_id     :integer
#  activity_date :datetime
#  contact_id    :integer
#  city          :string(255)
#  state         :string(255)
#  industry      :string(255)
#  comments      :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Activity < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact
  belongs_to :user
  has_and_belongs_to_many :models
end
