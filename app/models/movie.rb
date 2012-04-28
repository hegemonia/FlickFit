class Movie < ActiveRecord::Base
	has_many :reviews, :dependent => :destroy
  validates_uniqueness_of :title
end