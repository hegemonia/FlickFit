class Movie < ActiveRecord::Base
  has_many :reviews, :dependent => :destroy
  has_and_belongs_to_many :genres

  validates_uniqueness_of :title
  validates :synopsis, :length => { :maximum => 300 }
  validates :year, :numericality => { :only_integer => true, :greater_than => 999, :less_than => 10000 }
  validates :runtime, :numericality => { :only_integer => true, :greater_than => 99, :less_than => 1000 }
end