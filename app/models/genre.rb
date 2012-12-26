class Genre < ActiveRecord::Base
  include AppearsInCommaSeparatedList

  PrimaryTypes = [
    "Action",
    "Adventure",
    "Horror",
    "Comedy",
    "Family",
    "Drama",
    "Animation",
    "War",
    "Crime",
    "Fantasy",
    "Sci Fi",
    "Thriller",
    "Romance"
  ]

  Filters = PrimaryTypes + ["Action/Adventure", "Other"]

  validates_presence_of :name
  validates_uniqueness_of :name
end
