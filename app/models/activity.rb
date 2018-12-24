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
  has_many :activity_attachments, dependent: :destroy
  accepts_nested_attributes_for :activity_attachments
  belongs_to :client
  belongs_to :contact
  belongs_to :user
  has_and_belongs_to_many :models
  validates :client, :presence => true
  validates :activity_date, :presence => true

  def user_name
    return user.user_name
  end

  def self.create_from_import(activity_params)
    match_params = {activity_date: activity_params[:activity_date].in_time_zone("Eastern Time (US & Canada)"), client_id: activity_params[:client_id]}
    existing_activity = Activity.find_by(match_params)
    if existing_activity.nil?
      Activity.create(activity_params)
    else
      existing_activity
    end
  end

  def self.as_csv
    CSV.generate do |csv|
      x = column_names + ["contact_email", "users_email", "clients_name", "clients_eid", "models_name", "activity_attachments"]
      csv << x
      all.each do |item|
        y = item.attributes.values_at(*column_names) + [item.contact.nil? ? "" : item.contact.email] + [item.user.nil? ? "" : item.user.email] + [item.client.nil? ? "" : item.client.name] + [item.client.nil? ? "" : item.client.eid] + [item.models.pluck("name").join(",")] + [item.activity_attachments.pluck("attachment").join(",")]
        csv << y
      end
    end
  end

end
