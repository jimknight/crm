# == Schema Information
#
# Table name: activity_attachments
#
#  id          :integer          not null, primary key
#  activity_id :integer
#  attachment  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ActivityAttachment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  belongs_to :activity
end
