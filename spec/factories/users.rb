FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "Factory#{n}@example.com" }
    password 'factory'
    password_confirmation 'factory'
  end
end
