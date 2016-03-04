# == Schema Information
#
# Table name: activities
#
#  id            :integer          not null, primary key
#  client_id     :integer
#  activity_date :datetime
#  contact_id    :integer
#  city          :string
#  state         :string
#  industry      :string
#  comments      :text
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  attachment    :string
#

class Activity < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_activities, :against => [:city, :state, :comments]
  mount_uploader :attachment, AttachmentUploader
  belongs_to :client
  belongs_to :contact
  belongs_to :user
  has_and_belongs_to_many :models
  validates :client, :presence => true
  validates :activity_date, :presence => true
  def user_name
    return user.user_name
  end
end
