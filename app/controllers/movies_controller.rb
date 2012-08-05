class MoviesController < ApplicationController
    helper_method :sort_column
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default

  end

  def index
    @all_ratings = Movie.get_ratings
    @checked_ratings = params[:ratings] ||= session[:ratings] ||= {}
    @sort = params[:sort] ||= session[:sort]

    redirect_options = {:sort => params[:sort], :ratings => params[:ratings]}
    redirect = false


    if !params[:sort] and session[:sort]
      redirect = true
      redirect_options[:sort] = session[:sort]
    end
    
    if !params[:ratings] and session[:ratings]
      redirect = true
      redirect_options[:ratings] = session[:ratings]
    end

    if redirect
      redirect_to movies_path(redirect_options)
      
    end

    if @checked_ratings.length > 0
      @movies = Movie.all(:order => @sort, :conditions => {:rating => @checked_ratings.keys})
      
    else
      @movies = Movie.all(:order => @sort, :conditions => {})
    end

   
    
    
  end

  def new
    # default: render 'new' template

  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movie_url(@movie)
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

  private

  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
    
  end
end
