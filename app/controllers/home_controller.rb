class HomeController < ApplicationController
	include PeerScoreCalculator
  include HomeHelper

	before_filter :authenticate_user!

	REVIEWS_PER_PAGE = 10
	DEFAULT_PAGE_NUMBER = 1

	def index
    genre = Genre::Filters.include?(params[:genre]) ? params[:genre] : nil
		existing_reviews = (genre.present? ? Review.with_movie_genre(genre) : Review).where(:user_id => current_user.id)
    movie_relation = genre.present? ? Movie.with_genre(genre) : Movie
		
    unreviewed_movies = existing_reviews.any? ? movie_relation.where("movies.id not in (?)", existing_reviews.collect {|review| review.movie_id}) : movie_relation.all

		new_reviews = []
		unreviewed_movies.each do |movie|
			new_reviews << Review.new(:movie => movie, :user => current_user)
		end

		all_reviews = sort_reviews (existing_reviews + new_reviews), params[:order_by], nil
		current_page = params[:page].present? ? params[:page].to_i : DEFAULT_PAGE_NUMBER

    all_existing_reviews_for_user = Review.where(:user_id => current_user.id)
		@peer_scores = calculate_peer_scores all_existing_reviews_for_user

		@reviews = all_reviews.paginate(:page => current_page, :per_page => REVIEWS_PER_PAGE)
	end
end
