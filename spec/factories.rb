FactoryGirl.define do
  factory :movie do
    sequence :title do |n|
      "Scream #{n}"
    end
    runtime 111
    year 1996
  end
end

FactoryGirl.define do
  factory :review do
    association :movie, factory: :movie
    confidence 2
    rating 3
  end
end
