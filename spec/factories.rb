# This will guess the User class
FactoryGirl.define do
  factory :audit_log do
    user_id 1
    action "MyString"
    occurred_at "2018-09-28 13:23:17"
    email "MyString"
    controller "MyString"
    message "My message"
  end

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
