FactoryGirl.define do
  factory :genre do
    sequence(:name) { |n| "Factory Genre #{n}" }
  end
end

