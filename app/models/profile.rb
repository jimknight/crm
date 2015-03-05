# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user_id

  def admin
    self.user.admin
  end

end
