class Profile < ActiveRecord::Base

  belongs_to :user

  def admin
    self.user.admin
  end

end
