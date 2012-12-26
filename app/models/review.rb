class Review < ActiveRecord::Base
  DEFAULT_CONFIDENCE = 2
  belongs_to :movie
  belongs_to :user
  validates :user, presence: true

  def self.with_movie_genre primary_genre_type
    if primary_genre_type == "Other"
      joins("INNER JOIN movies ON movies.id = reviews.movie_id LEFT OUTER JOIN movie_genres ON movie_genres.movie_id = movies.id LEFT OUTER JOIN genres ON genres.id = movie_genres.genre_id").
        where("genres.name IS NULL OR genres.name NOT IN (?)", Genre::PrimaryTypes).uniq
    else
      genres = primary_genre_type.split('/')
      joins(:movie => :genres).where("genres.name in (?)", genres)
    end
  end
end
