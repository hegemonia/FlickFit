class ReviewsController < ApplicationController
  include PeerScoreCalculator

  before_filter :authenticate_user!
  before_filter :set_peer_scores, :only => [:create, :update, :destroy]

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
    confidence = review_params[:confidence].present? ? review_params[:confidence] : Review::DEFAULT_CONFIDENCE
    @review = Review.new :movie_id => review_params[:movie_id], :rating => review_params[:rating], :confidence => confidence, :user_id => current_user.id
    @review.save unless review_params[:rating].blank?
    respond_to do |format|
      format.html { redirect_to home_path }
      format.js
    end
  end

  def update
    @review = Review.find_by_id params[:id]
    confidence = params[:review][:confidence].present? ? params[:review][:confidence] : Review::DEFAULT_CONFIDENCE
    modified_params = params[:review].merge({:user_id => current_user.id, :confidence => confidence})

    @review.update_attributes(modified_params)
    respond_to do |format|
      format.html { redirect_to home_path }
      format.js
    end
  end

  def destroy
    review = Review.find_by_id params[:id]
    @review = Review.new :movie => review.movie, :user => current_user
    review.destroy
    respond_to do |format|
      format.html { redirect_to home_path }
      format.js
    end
  end

private
  def set_peer_scores
    reviews = Review.where :user_id => current_user.id
    @peer_scores = calculate_peer_scores reviews
  end
end
