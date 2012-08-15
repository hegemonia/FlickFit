class Review < ActiveRecord::Base
  DEFAULT_CONFIDENCE = 2
	belongs_to :movie
	belongs_to :user

  def self.with_movie_genre genre
    if genre == "Other"
      joins("INNER JOIN movies ON movies.id = reviews.movie_id LEFT OUTER JOIN genres_movies ON genres_movies.movie_id = movies.id LEFT OUTER JOIN genres ON genres.id = genres_movies.genre_id").
        where("genres.name IS NULL OR genres.name NOT IN (?)", Genre::PrimaryTypes.join(",")).uniq
    else
      joins(:movie => :genres).where(:genres => {:name => genre})
    end
  end
end
