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
#  start_date :date
#  end_date   :date
#  contact_id :integer
#

class Appointment < ActiveRecord::Base

  belongs_to :client
  belongs_to :contact
  belongs_to :user
  validates :client_id, :title, :start_time, :end_time, :presence => true
  def pretty_calendar_date
    return start_time.strftime("%Y-%m-%d")
  end

end
