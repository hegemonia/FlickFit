class ReviewCountMismatch < Exception; end
class ReviewComparator
	def calculate_similarity reviews1_arg, reviews2_arg
    raise(ReviewCountMismatch, "The length of each review collection must be equal") if reviews1_arg.length != reviews2_arg.length
		reviews1 = reviews1_arg.dup
		reviews2 = reviews2_arg.dup

		reviews1.sort_by! {|review| review.movie_id }
		reviews2.sort_by! {|review| review.movie_id }
		movie_count = reviews1.length
		movie_scores = []
		average_confidence_scores = []
		while reviews1.any?
			movie_score, confidence = calculate_movie_similarity(reviews1.shift, reviews2.shift)
			average_confidence_scores << confidence
			movie_scores << movie_score
		end
		weighted_score = movie_scores.sum / average_confidence_scores.sum
		similarity_score = (10 - (weighted_score + (8.0 / movie_count))).round(2)
		[similarity_score, 0].max
	end

	def calculate_movie_similarity movie1, movie2
		square_of_rating_difference = ((movie1.rating.to_f - movie2.rating.to_f)**2) * 2
		average_confidence = (movie1.confidence.to_f + movie2.confidence.to_f)/2.0

		return (square_of_rating_difference * average_confidence), average_confidence
	end
end

