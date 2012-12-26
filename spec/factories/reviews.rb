FactoryGirl.define do
  factory :review do
    association :movie, factory: :movie
    confidence 2
    rating 3
    association :user, factory: :user
  end
end

