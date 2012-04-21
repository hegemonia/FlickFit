class MoviesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :require_admin_role

  def index
  	@movies = Movie.all
  end

  def new
 		@movie = Movie.new
  end

  def create
  	movie_params = params[:movie]
  	Movie.create :title => movie_params[:title]
		redirect_to movies_path
  end

  def edit
  	@movie = Movie.find params[:id]
  end

  def update
  	movie_params = params[:movie]
  	movie = Movie.find params[:id]
  	movie.update_attributes :title => movie_params[:title]
  	redirect_to movies_path
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    redirect_to movies_path
  end
end
