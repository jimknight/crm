# == Schema Information
#
# Table name: contacts
#
#  id                   :integer          not null, primary key
#  name                 :string
#  title                :string
#  email                :string
#  work_phone           :string
#  mobile_phone         :string
#  client_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  contact_description  :string
#  work_phone_extension :string
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
