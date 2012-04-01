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
		@user_comparison_hash = {}

		reviewed_movie_ids = existing_reviews.map(&:movie_id)
		all_users.each do |user|
			other_user_reviews = user.reviews.select {|review| reviewed_movie_ids.include? review.movie_id }
			other_reviewed_movie_ids = other_user_reviews.map(&:movie_id)

			current_user_reviews = existing_reviews.select {|review| other_reviewed_movie_ids.include? review.movie_id}
			logger.error "CURRENT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
			logger.error current_user_reviews
			logger.error "OTHER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
			logger.error other_user_reviews
			logger.error "DONE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
			logger.error current_user_reviews.map(&:confidence)
			logger.error other_user_reviews.map(&:confidence)
			logger.error comparator.calculate_similarity(current_user_reviews, other_user_reviews) if !other_user_reviews.empty?
			logger.error current_user_reviews.map(&:confidence)
			logger.error other_user_reviews.map(&:confidence)
			logger.error user.email
			@user_comparison_hash["#{user.email}"] = comparator.calculate_similarity(current_user_reviews, other_user_reviews) if !other_user_reviews.empty?
			logger.error @user_comparison_hash
		end
	end
end