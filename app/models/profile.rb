# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  time_zone  :string
#

class Profile < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user_id

  def admin
    self.user.admin
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
