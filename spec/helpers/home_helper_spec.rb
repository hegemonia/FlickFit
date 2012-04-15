require 'spec_helper'

describe "HomeHelper" do
	class FakeHomeIncluder
		include HomeHelper
	end

	it "should be able to calculate a prediction score" do
		chris = User.create :email => "chris@test.com", :password => "boop123"
		richard = User.create :email => "richard@test.com", :password => "boop123"
		anup = User.create :email => "anup@test.com", :password => "boop123"

		matrix = Movie.create :title => "The Matrix"

		chris_review = Review.create :user => chris, :movie => matrix, :rating => 3.0, :confidence => 2
		richard_review = Review.create :user => richard, :movie => matrix, :rating => 4.0, :confidence => 2
		anup_review = Review.create :user => anup, :movie => matrix, :rating => 5.0, :confidence => 3

		scores_hash = {chris => 9.0, richard => 8.0, anup => 7.0}

		FakeHomeIncluder.new.calculate_prediction_score(Review.new(:movie => matrix), scores_hash).should == 4.05
	end
end