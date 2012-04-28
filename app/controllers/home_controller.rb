class HomeController < ApplicationController
	include PeerScoreCalculator

	before_filter :authenticate_user!

	REVIEWS_PER_PAGE = 10
	DEFAULT_PAGE_NUMBER = 1

	def index
		user = current_user
		existing_reviews = Review.where :user_id => user.id

		unreviewed_movies = existing_reviews.any? ? Movie.where("id not in (?)", existing_reviews.collect {|review| review.movie_id}) : Movie.all

		new_reviews = []
		unreviewed_movies.each do |movie|
			new_reviews << Review.new(:movie => movie, :user => user)
		end
		@peer_scores = calculate_peer_scores existing_reviews

		all_reviews = (existing_reviews + new_reviews).sort_by {|review| review.movie.title}
		current_page = params[:page].present? ? params[:page].to_i : DEFAULT_PAGE_NUMBER
		@reviews = all_reviews.paginate(:page => current_page, :per_page => REVIEWS_PER_PAGE)
	end
end