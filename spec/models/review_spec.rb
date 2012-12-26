require 'spec_helper'

describe Review do
  it { should belong_to :user }
  it { should validate_presence_of :user }

  context "with_movie_genre" do
    it "should return reviews of movies with the given genre" do
      horror_movie = FactoryGirl.create :movie
      horror_movie.genres = [Genre.create(:name => "Horror")]
      review = FactoryGirl.create :review, :movie => horror_movie
      Review.with_movie_genre("Horror").should == [review]
    end

    it "should not return reviews of movies without the given genre" do
      movie = FactoryGirl.create :movie
      movie.genres = [Genre.create(:name => "Comedy")]
      movie_without_a_genre = FactoryGirl.create :movie
      review1 = FactoryGirl.create :review, :movie => movie
      review2 = FactoryGirl.create :review, :movie => movie_without_a_genre
      Review.with_movie_genre("Horror").should be_empty
    end

    context "given the Other genre type" do
      it "should return reviews of movies without a primary genre type" do
        clown_boxing = Genre.create :name => "Clown Boxing"
        movie = FactoryGirl.create :movie
        movie.genres = [clown_boxing]
        horror_movie = FactoryGirl.create :movie
        horror_movie.genres = [Genre.create(:name => "Horror")]
        clown_boxing_review = FactoryGirl.create :review, :movie => movie
        horror_review = FactoryGirl.create :review, :movie => horror_movie
        Review.with_movie_genre("Other").should == [clown_boxing_review]
      end

      it "should return reviews of movies that have a primary genre and a non primary genre" do
        clown_boxing = Genre.create :name => "Clown Boxing"
        horror = Genre.create :name => "Horror"
        movie = FactoryGirl.create :movie
        movie.genres = [clown_boxing, horror]
        review = FactoryGirl.create :review, :movie => movie
        Review.with_movie_genre("Other").should == [review]
      end

      it "should return reviews of movies without a genre" do
        movie = FactoryGirl.create :movie, :genres => []
        review = FactoryGirl.create :review, :movie => movie
        Review.with_movie_genre("Other").should == [review]
      end
    end
  end
end

