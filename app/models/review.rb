class Review < ActiveRecord::Base
  DEFAULT_CONFIDENCE = 2
	belongs_to :movie
	belongs_to :user
end