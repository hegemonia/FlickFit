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
    create_or_update_movie params do |success|
      success ? redirect_to(movies_path) : render(:new)
    end
  end

  def edit
  	@movie = Movie.find params[:id]
  end

  def update
    create_or_update_movie params do |success|
      success ? redirect_to(movies_path) : render(:edit)
    end
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    redirect_to movies_path
  end

  private

  def create_or_update_movie(params)
    @movie = params[:id].present? ? Movie.find(params[:id]) : Movie.new
    movie_params = params[:movie]
    if @movie.update_attributes :title => movie_params[:title],
        :runtime => movie_params[:runtime],
        :synopsis => movie_params[:synopsis],
        :year => movie_params[:year],
        :genres => Genre.in_comma_separated_list(movie_params[:genres_list]),
        :directors => Person.in_comma_separated_list(movie_params[:directors_list]),
        :actors => Person.in_comma_separated_list(movie_params[:actors_list])
      yield true
    else
      flash[:error] = @movie.errors.full_messages.to_sentence
      yield false
    end
  end
end
