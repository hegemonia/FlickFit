class ReviewsController < ApplicationController
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
	end

	def create
		Review.create(params[:review].merge({:user_id => current_user.id}))
		redirect_to reviews_path
	end
end
