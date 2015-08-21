# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable
  has_many :activities
  has_many :appointments
  has_and_belongs_to_many :clients
  has_one  :profile
  after_create :create_child_profile

  def create_child_profile
    self.build_profile(:first_name => "", :last_name => "")
    self.profile.save!
  end

  def user_name
    if self.profile && self.profile.first_name.present?
      return "#{self.profile.first_name} #{self.profile.last_name}"
    else
      return self.email
    end
  end

end
