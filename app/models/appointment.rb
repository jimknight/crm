# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  client_id  :integer
#  user_id    :integer
#  start_time :datetime
#  end_time   :datetime
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#

class Appointment < ActiveRecord::Base

  belongs_to :client
  belongs_to :user

  def pretty_calendar_date
    return start_time.strftime("%Y-%m-%d")
  end

end
