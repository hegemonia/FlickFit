module HomeHelper
  def calculate_prediction_score review, scores_hash
    other_reviews = Review.where(:movie_id => review.movie_id)
    calculate_weighted_average(other_reviews, scores_hash) if !other_reviews.empty?
  end

  def calculate_average_score review
    reviews = Review.where(:movie_id => review.movie_id)
    return 0 unless reviews.any?
    ratings = reviews.collect {|rev| rev.rating}
    (ratings.sum / ratings.count).round(2)
  end

  def number_of_ratings_for movie
    Review.count(:conditions => {:movie_id => movie.id})
  end

  def sort_reviews reviews, order_by, direction
    ordering_callbacks = {
      "title" => lambda { |rs| reviews.sort_by {|review| review.movie.title }},
      "predicted rating" => lambda {|rs| reviews.sort_by {|review| calculate_prediction_score(review, @peer_scores) }},
      "average rating" => lambda {|rs| reviews.sort_by {|review| calculate_average_score(review) }}
    }

    if !order_by.nil?
      return ordering_callbacks[order_by].call(reviews)
    end

    return ordering_callbacks["title"].call(reviews)
  end

  private

  def calculate_weighted_average reviews, scores_hash
    weights = []
    products = []
    scores_hash.each do |user, peer_score|
      review = reviews.detect {|rev| rev.user_id == user.id}
      next unless review
      weight = peer_score**2 * review.confidence
      weights << weight
      products << (weight * review.rating)
    end
    return (products.sum / weights.sum).round(2) if !weights.empty? && !products.empty?
  end
end
