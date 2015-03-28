module ActivitiesHelper

  def attachment_is_image?
    if @activity.attachment_url.present?
      return /(.+\.(?:png|jpg|gif|jpeg|icon))/i.match(@activity.attachment_url)
    end
    return false
  end

end
