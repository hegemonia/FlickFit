class HomeController < ApplicationController
	before_filter :authenticate_user!
	def index
		@user = current_user
		existing_reviews = Review.where :user_id => @user.id
		movies = existing_reviews.any? ? Movie.where("id not in (?)", existing_reviews.collect {|review| review.movie_id}) : Movie.all
																		

		new_reviews = []
		movies.each do |movie|
			new_reviews << Review.new(:movie => movie, :user => @user)
		end

		@reviews = (existing_reviews + new_reviews).sort_by {|review| review.movie.title}

		comparator = ReviewComparator.new
		all_users = User.all
		user_comparison_hash = {}

		reviewed_movie_ids = existing_reviews.map(&:movie_id)
		all_users.each do |user|
			other_user_reviews = user.reviews.select {|review| reviewed_movie_ids.include? review.movie_id }
			other_reviewed_movie_ids = other_user_reviews.map(&:movie_id)

			current_user_reviews = existing_reviews.select {|review| other_reviewed_movie_ids.include? review.movie_id}
			user_comparison_hash["#{user.email}"] = comparator.calculate_similarity(current_user_reviews, other_user_reviews) if !other_user_reviews.empty?
		end
		@peer_scores = user_comparison_hash.sort_by {|k,v| v }.reverse
	end
end