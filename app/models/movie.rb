class Movie < ActiveRecord::Base
  has_many :reviews, :dependent => :destroy
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :directors, :class_name => Person.name, :join_table => "movies_directors"
  has_and_belongs_to_many :actors, :class_name => Person.name, :join_table => "movies_actors"

  validates_uniqueness_of :title
  validates :synopsis, :length => { :maximum => 360 }
  validates :runtime, :numericality => { :only_integer => true, :less_than => 1000 }
  validates :year, :numericality => { :only_integer => true, :greater_than => 999, :less_than => 10000 }
end