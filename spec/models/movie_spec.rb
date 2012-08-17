require 'spec_helper'

describe "Movie" do
	context "with_genre" do
    it "should return movies with the given genre" do
      movie = FactoryGirl.create :movie
      horror = Genre.create :name => "Horror"
      movie.genres = [horror]
      Movie.with_genre("Horror").should == [movie]
    end

    it "should not return movies without the given genre" do
      movie = FactoryGirl.create :movie
      movie_without_a_genre = FactoryGirl.create :movie
      movie.genres = [Genre.create(:name => "Comedy")]
      Movie.with_genre("Horror").should be_empty
    end

    context "given the Other genre type" do
      it "should return movies without a primary genre type" do
        clown_boxing = Genre.create :name => "Clown Boxing"
        movie = FactoryGirl.create :movie
        movie.genres = [clown_boxing]
        horror_movie = FactoryGirl.create :movie
        horror_movie.genres = [Genre.create(:name => "Horror")]
        Movie.with_genre("Other").should == [movie]
      end

      it "should return movies that have a primary genre and a non primary genre" do
        clown_boxing = Genre.create :name => "Clown Boxing"
        horror = Genre.create :name => "Horror"
        movie = FactoryGirl.create :movie
        movie.genres = [clown_boxing, horror]
        Movie.with_genre("Other").should == [movie]
      end

      it "should return movies without a genre" do
        movie = FactoryGirl.create :movie
        Movie.with_genre("Other").should == [movie]
      end
    end
  end
end
