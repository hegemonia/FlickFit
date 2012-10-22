class Movie < ActiveRecord::Base
  has_many :reviews, :dependent => :destroy
  has_many :movie_genres, :dependent => :destroy
  has_many :genres, :through => :movie_genres
  has_and_belongs_to_many :directors, :class_name => Person.name, :join_table => "movies_directors"
  has_and_belongs_to_many :actors, :class_name => Person.name, :join_table => "movies_actors"

  validates_uniqueness_of :title
  validates :synopsis, :length => { :maximum => 360 }
  validates :runtime, :numericality => { :only_integer => true, :less_than => 1000 }
  validates :year, :numericality => { :only_integer => true, :greater_than => 999, :less_than => 10000 }

  def self.with_genre primary_genre_type
    if primary_genre_type == "Other"
      joins("LEFT OUTER JOIN movie_genres ON movie_genres.movie_id = movies.id LEFT OUTER JOIN genres ON genres.id = movie_genres.genre_id").
        where("genres.name IS NULL OR genres.name NOT IN (?)", Genre::PrimaryTypes).uniq
    else
      genres = primary_genre_type.split('/')
      joins(:genres).where("genres.name in (?)", genres)
    end
  end

  def formatted_year
    self.year.nil? ? "Year: N/A" : "(" + self.year.to_s + ")"
  end

  def formatted_runtime
    self.runtime.nil? ? "Runtime: N/A" : self.runtime.to_s + " minutes (" + runtime_hours + " hours, " + runtime_minutes + " minutes)"
  end

  def formatted_genres
    self.genres.empty? ? "Genre: N/A" : self.genres.map! { |genre| genre.name }.join(" | ")
  end

  def formatted_synopsis
    self.synopsis.nil? ? "N/A" : self.synopsis
  end

  def formatted_directors
    self.directors.empty? ? "N/A" : self.directors.map! { |director| director.name }.join(", ")
  end

  def formatted_actors
    self.actors.empty? ? "N/A" : self.actors.map! { |actor| actor.name }.join(", ")
  end

  def runtime_hours
    (self.runtime / 60).to_s
  end

  def runtime_minutes
    (self.runtime % 60).to_s
  end

  def genres=(genres)
    self.movie_genres = []
    position = 0
    genres.each do |genre|
      movie_genre = MovieGenre.find_or_initialize_by_movie_and_genre(self, genre)
      movie_genre.position = position
      self.movie_genres << movie_genre
      position +=1
    end
  end

  def genres
    self.movie_genres.map(&:genre)
  end
end
