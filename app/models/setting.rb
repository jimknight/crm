# == Schema Information
#
# Table name: settings
#
#  id                             :integer          not null, primary key
#  notify_on_new_prospect_contact :text
#  created_at                     :datetime
#  updated_at                     :datetime
#

class Setting < ActiveRecord::Base
end
