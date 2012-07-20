class Genre < ActiveRecord::Base
  include AppearsInCommaSeparatedList

  validates_presence_of :name
  validates_uniqueness_of :name
end