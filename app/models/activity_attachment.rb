class ActivityAttachment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  belongs_to :activity
end
