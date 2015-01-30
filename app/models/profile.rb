class Profile < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user_id

  def admin
    self.user.admin
  end

end
