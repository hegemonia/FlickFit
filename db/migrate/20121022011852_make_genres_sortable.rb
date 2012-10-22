class Movie < ActiveRecord::Base
  has_many :movie_genres, :dependent => :destroy
end

class MovieGenre < ActiveRecord::Base
end

class MakeGenresSortable < ActiveRecord::Migration
  def up
    rename_table :genres_movies, :movie_genres
    add_column :movie_genres, :position, :integer

    Movie.all.each do |movie|
      position = 0
      movie.movie_genres.each do |movie_genre|
        movie_genre.position = position
        movie_genre.save!(:validate => false)
        position += 1
      end
    end
  end

  def down
    remove_column :movie_genres, :position
    rename_table :movie_genres, :genres_movies
  end
end
