require 'spec_helper'

describe "ReviewComparator" do
	context "calculate_similarity" do
		it "should work" do
			gladiator = Movie.create :title => "Gladiator"
			matrix = Movie.create :title => "Matrix"
			
			tom = User.create :email => "Tom@test.com", :password => "boop123"
			richard = User.create :email => "Richard@test.com", :password => "boop123"
			
			toms_gladiator_review = Review.create :movie => gladiator, :rating => 2, :confidence => 3, :user => tom
			toms_matrix_review = Review.create :movie => matrix, :rating => 5, :confidence => 2, :user => tom
			richards_gladiator_review = Review.create :movie => gladiator, :rating => 5, :confidence => 2, :user => richard
			richards_matrix_review = Review.create :movie => matrix, :rating => 4, :confidence => 1, :user => richard

			toms_reviews = [toms_matrix_review, toms_gladiator_review]
			richards_reviews = [richards_matrix_review, richards_gladiator_review]
			similarity_score = ReviewComparator.new.calculate_similarity(toms_reviews, richards_reviews)
			similarity_score.should == -6.0
		end

		it "should raise an exception when the review counts are not equal" do
			review1 = Review.create :movie => Movie.create(:title => "Test")
			review2 = Review.create :movie => Movie.create(:title => "Test2")
			lambda { ReviewComparator.new.calculate_similarity([review1], [review1,review2]) }.should raise_error
		end

		it "should not raise an exception when the review counts are equal" do
			review1 = Review.create :movie => Movie.create(:title => "Test")
			review2 = Review.create :movie => Movie.create(:title => "Test2")
			lambda { ReviewComparator.new.calculate_similarity([review1,review2], [review1,review2]) }.should_not raise_error
		end
	end
end
