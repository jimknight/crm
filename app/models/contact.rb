# == Schema Information
#
# Table name: contacts
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  title                :string(255)
#  email                :string(255)
#  work_phone           :string(255)
#  mobile_phone         :string(255)
#  client_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  contact_description  :string(255)
#  work_phone_extension :string(255)
#  comments             :text
#

class Contact < ActiveRecord::Base
  belongs_to :client

  def pretty_work_phone_extension
    if self.work_phone_extension.downcase.include?("x")
      return self.work_phone_extension
    else
      return "x#{self.work_phone_extension}"
    end
  end
end
