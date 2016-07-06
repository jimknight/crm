# == Schema Information
#
# Table name: settings
#
#  id                             :integer          not null, primary key
#  notify_on_new_prospect_contact :text
#  created_at                     :datetime
#  updated_at                     :datetime
#  notify_on_client_delete        :text
#  notify_on_invalid_json         :text
#

class Setting < ActiveRecord::Base

  def self.get_notify_on_client_delete_recipients
    @settings_doc = Setting.first
    if @settings_doc.nil?
      return ""
    else
      @send_to = @settings_doc.notify_on_client_delete
      if @send_to.present?
        return @send_to
      else
        return ""
      end
    end
  end

end
