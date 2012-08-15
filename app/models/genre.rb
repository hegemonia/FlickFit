class Genre < ActiveRecord::Base
  include AppearsInCommaSeparatedList

  PrimaryTypes = [
    "Action",
    "Horror",
    "Comedy",
    "Family",
    "Drama"
  ]

  Filters = PrimaryTypes + ["Other"]

  validates_presence_of :name
  validates_uniqueness_of :name
end
