class UsersController < ApplicationController
  before_action :set_user, only: [:favorites, :favorite_movie, :show, :edit, :update, :destroy]
  before_action :set_movies, only: [:favorites, :favorite_movie]

  # GET /users
  # GET /users.json
  def index
    @users = User.users_by_name
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Delete the underage users
  def delete_underage
    @users = User.all

    @users.each do |u|
      if (u.age < 18)
          u.destroy
        end
    end

    @users = User.users_by_name
    render 'index'

  end

  #Add or Delete a favorite movie to a user
  def favorite_movie
    @my_movies = @user.movies
    movie = Movie.find(params[:movie_id])

    unless @my_movies.include? movie
      @user.movies << movie
    else
      @user.movies.delete(movie)
    end
    
    @user.save

    render 'favorites'
  end


  #Show all favorites
  def favorites
    @my_movies = @user.movies
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :age, :gender)
    end

    # To get all the movies of the database
    def set_movies
      @movies = Movie.all
    end
end
