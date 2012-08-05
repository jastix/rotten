class MoviesController < ApplicationController
    helper_method :sort_column
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default

  end

  def index
    @all_ratings = Movie.get_ratings
    @checked_ratings = params[:ratings]
    @sort = params[:sort]

    if @checked_ratings == nil and @sort == nil
      @checked_ratings = session[:ratings]
      @sort = session[:sort]
      flash.keep
      redirect_to :action => "index", :sort => @sort, :ratings => @checked_ratings if @sort || @checked_ratings
    end
    

    if @checked_ratings
      @movies = Movie.all(:order => @sorted, :conditions => {:rating => @checked_ratings.keys}) 
    else
      @checked_ratings = {}
      @movies = Movie.all(:order => @sort)
    end
    
    session[:sort] = @sort
    session[:ratings] = @checked_ratings
    
    
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
