class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title_class = ""
    @release_class = ""
    @all_ratings = Movie.get_ratings
    @checked_ratings = params[:ratings]
    if @checked_ratings != nil
      query = Movie.where(:rating => @checked_ratings.keys)
    else
      args = {}
      @all_ratings.each do |rating|
        args[rating] = true
      end
      redirect_to movies_path(args)
    end
    if params.has_key?(:sort_by)
      if params[:sort_by] == "title"
        query = query.order("title")
        @title_class = "hilite"
      elsif params[:sort_by] == "release_date"
        query = query.order("release_date")
        @release_class = "hilite"
      end
    end
    @movies = query.find(:all)
  end

  def new
    # default: render 'new' template
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
