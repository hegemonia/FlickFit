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
		review_params = params[:review]
		@review = Review.new :movie_id => review_params[:movie_id], :rating => review_params[:rating], :confidence => review_params[:confidence], :user_id => current_user.id
		@review.save
		respond_to do |format|
			format.html { redirect_to reviews_path }
			format.js
		end
	end

	def update
		review = Review.find_by_id params[:id]
		review.update_attributes(params[:review].merge({:user_id => current_user.id}))
		redirect_to reviews_path
	end
end
