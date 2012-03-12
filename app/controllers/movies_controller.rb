class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = {}
    if(params[:ratings])
      @selected_ratings = params[:ratings]
      conditions = @selected_ratings.keys.map {|k| "rating = '#{k}'"}.join " OR "
    end
    
    @all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
    @movies = Movie.order(params[:sort]).where(conditions)
    @hilite = params[:sort]
  end

  def new
    # default: render 'new' template
    @all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
