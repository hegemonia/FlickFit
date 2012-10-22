class MovieGenre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :genre
  acts_as_list :top_of_list => 0

  class << self
    def find_or_initialize_by_movie_and_genre(movie, genre)
      result = MovieGenre.where(:movie_id => movie.id, :genre_id => genre.id).first
      result || MovieGenre.new(:movie => movie, :genre => genre)
    end
  end
end
