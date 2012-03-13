class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    do_redirect = false

    if(params[:ratings])
      session[:ratings] = params[:ratings]
    elsif(session[:ratings])
      if(params[:commit])
        session.delete :ratings
      else
        do_redirect
      end
    end

    if(params[:sort])
      session[:sort] = params[:sort]
    else
      do_redirect = true if session[:sort]
    end

    doRESTfulRedirect if do_redirect

    @all_ratings = Movie.ratings
    @movies = Movie.order(session[:sort]).where(ratings_conditions)
    @hilite = params[:sort]
  end

  def ratings_conditions
    session[:ratings].keys.map {|rating| "rating = '#{rating}'"}.join ' OR ' if session[:ratings]
  end

  def doRESTfulRedirect
    redirect_to getRESTfulLink
  end

  def getRESTfulLink
    movies_path(:ratings => session[:ratings], :sort => session[:sort])
  end

  def new
    # default: render 'new' template
    @all_ratings = Movie.ratings
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
    @all_ratings = Movie.ratings
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
