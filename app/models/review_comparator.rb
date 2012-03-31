class ReviewComparator
	def initialize
		@average_confidence_scores = []
		@movie_scores = []
	end

	def calculate_similarity reviews1, reviews2
		raise(ReviewCountMismatch, "The length of each review collection must be equal") if reviews1.length != reviews2.length
    reviews1.sort_by! {|review| review.movie_id }
    reviews2.sort_by! {|review| review.movie_id }
    movie_count = reviews1.length
    while reviews1.any?
	    @movie_scores << calculate_movie_similarity(reviews1.shift, reviews2.shift)
	  end
    weighted_score = @movie_scores.sum / @average_confidence_scores.sum

    10 - (weighted_score + (4.0 / movie_count**2))
 	end

 	def calculate_movie_similarity movie1, movie2
 		square_of_rating_difference = (movie1.rating.to_f - movie2.rating.to_f)**2
 		average_confidence = (movie1.confidence.to_f + movie2.confidence.to_f)/2.0

 		@average_confidence_scores << average_confidence

 		square_of_rating_difference * average_confidence
 	end
end

class ReviewCountMismatch; end