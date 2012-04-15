class HomeController < ApplicationController
	before_filter :authenticate_user!
	def index
		user = current_user
		existing_reviews = Review.where :user_id => user.id

		unreviewed_movies = existing_reviews.any? ? Movie.where("id not in (?)", existing_reviews.collect {|review| review.movie_id}) : Movie.all

		new_reviews = []
		unreviewed_movies.each do |movie|
			new_reviews << Review.new(:movie => movie, :user => user)
		end

		@reviews = (existing_reviews + new_reviews).sort_by {|review| review.movie.title}
		@peer_scores = calculate_peer_scores existing_reviews
	end

	private

	def calculate_peer_scores reviews
		comparator = ReviewComparator.new
		all_users = User.all
		user_comparison_hash = {}

		reviewed_movie_ids = reviews.map(&:movie_id)

		all_users.each do |user|
			next if user == current_user
			other_user_reviews = user.reviews.select {|review| reviewed_movie_ids.include? review.movie_id }
			other_reviewed_movie_ids = other_user_reviews.map(&:movie_id)

			reviews_of_the_same_movies = reviews.select {|review| other_reviewed_movie_ids.include? review.movie_id}

			user_comparison_hash[user] = comparator.calculate_similarity(reviews_of_the_same_movies, other_user_reviews) if !other_user_reviews.empty?
		end
		user_comparison_hash.sort_by {|k,v| v }.reverse
	end
end