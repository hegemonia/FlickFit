FactoryGirl.define do
  factory :movie do
    sequence :title do |n|
      "Scream #{n}"
    end
    runtime 111
    year 1996
    genres { [FactoryGirl.create(:genre)] }
  end
end

