class Activity < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact
end
