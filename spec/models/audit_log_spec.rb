# == Schema Information
#
# Table name: audit_logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  action     :string
#  email      :string
#  controller :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AuditLog, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
