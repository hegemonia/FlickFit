require 'spec_helper'

describe HomeController do
  before { sign_in @current_user=FactoryGirl.create(:user) }
  describe 'GET index' do
    context 'unreviewed movies' do
      let!(:unreviewed_movie) { FactoryGirl.create :movie }
      before { get :index }

      it 'should initialize a new review for an unreviewed movie' do
        assigns(:reviews).count.should == 1
        new_review = assigns(:reviews).first
        new_review.movie_id.should == unreviewed_movie.id
        new_review.user_id.should == @current_user.id
      end

      describe 'filtering by genre' do
        let(:horror) { FactoryGirl.create :genre, name: 'Horror' }
        let!(:horror_movie) { FactoryGirl.create :movie, genres: [horror] }
        let(:comedy) { FactoryGirl.create :genre, name: 'Comedy' }
        let!(:comedy_movie) { FactoryGirl.create :movie, genres: [comedy] }

        before { get :index, genre: 'Horror' }

        it 'should only return reviews for movies of the selected genre' do
          assigns(:reviews).length.should == 1
          assigns(:reviews).first.movie_id.should == horror_movie.id
        end
      end

      describe 'filtering by a composite genre' do
        let(:action) { FactoryGirl.create :genre, name: 'Action' }
        let!(:action_movie) { FactoryGirl.create :movie, genres: [action] }
        let(:adventure) { FactoryGirl.create :genre, name: 'Adventure' }
        let!(:adventure_movie) { FactoryGirl.create :movie, genres: [adventure] }
        let!(:action_adventure_movie) { FactoryGirl.create :movie, genres: [action, adventure] }

        before { get :index, genre: 'Action/Adventure' }

        it 'should return movies that match either genre' do
          assigns(:reviews).length.should == 3
          assigns(:reviews).map(&:movie_id).should =~ [action_movie.id, adventure_movie.id, action_adventure_movie.id]
        end
      end
    end

    context 'reviewed movies' do
      describe 'filtering by a composite genre' do
        let(:action) { FactoryGirl.create :genre, name: 'Action' }
        let(:action_movie) { FactoryGirl.create :movie, genres: [action] }
        let(:adventure) { FactoryGirl.create :genre, name: 'Adventure' }
        let(:adventure_movie) { FactoryGirl.create :movie, genres: [adventure] }
        let(:action_adventure_movie) { FactoryGirl.create :movie, genres: [action, adventure] }

        let!(:action_review) { FactoryGirl.create :review, movie_id: action_movie.id, user_id: @current_user.id }
        let!(:adventure_review) { FactoryGirl.create :review, movie_id: adventure_movie.id, user_id: @current_user.id }
        let!(:action_adventure_review) { FactoryGirl.create :review, movie_id:action_adventure_movie.id, user_id: @current_user.id }
        before { get :index, genre: 'Action/Adventure' }

        it 'should return movies that match either genre' do
          assigns(:reviews).length.should == 3
          assigns(:reviews).map(&:movie_id).should =~ [action_movie.id, adventure_movie.id, action_adventure_movie.id]
        end
      end
    end
  end
end
