# This will guess the User class
FactoryGirl.define do

  factory :client do
    sequence(:name) { |n| "Client ##{n}" }
  end

  factory :activity do
    activity_date Time.now
    association :client
  end

  factory :user do
    email "user@sga.com"
    password "ilovesga"
    password_confirmation "ilovesga"
  end

end
