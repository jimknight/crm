class Activity < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact
  has_and_belongs_to_many :models
end
