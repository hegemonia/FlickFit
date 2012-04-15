module HomeHelper
	def calculate_prediction_score review, scores_hash
		other_reviews = Review.where(:movie_id => review.movie_id)
		calculate_weighted_average(other_reviews, scores_hash) if !other_reviews.empty?
	end

	private

	def calculate_weighted_average reviews, scores_hash
		weights = []
		products = []
		scores_hash.each do |user, peer_score|
			review = reviews.detect {|rev| rev.user_id == user.id}
			next unless review
			weight = peer_score * review.confidence
			weights << weight
			products << (weight * review.rating)
		end
		return (products.sum / weights.sum).round(2) if !weights.empty? && !products.empty?
	end
end
