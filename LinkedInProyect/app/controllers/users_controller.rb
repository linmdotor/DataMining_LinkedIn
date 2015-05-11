class UsersController < ApplicationController
  before_action :set_user, only: [:skills, :modify_skills, :show, :edit, :update, :destroy]
  before_action :set_skills, only: [:skills, :modify_skills]

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
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
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
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
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

  #Add or Delete a skill
  def modify_skills
    @my_skills = @user.skills
    skill = Skill.find(params[:skill_id])

    unless @my_skills.include? skill
      @user.skills << skill
    else
      @user.skills.delete(skill)
    end

    @user.save

    render 'skills'
  end


  #Show all skills
  def skills
    @my_skills = @user.skills
  end


  def simPerson(myName)

    comp = Company.where(:name => company).pluck(:_id)[0].to_s
    allEmp = User.where(:company_id => comp).pluck(:name, :skill_ids).to_a
    myUser = User.where(:name => myName).pluck(:skill_ids).to_a

    countSkills = Array.new(allEmp.length) {0};

    myUser.each do |skill|
      (0...(allEmp.length)).each do |i|
        if allEmp[i].include?(skill)
          countSkills[i] += 1;
        end
      end
    end

    (0...(countSkills.length)).each do |i|
      countSkills[i] /= myUser.length.to_f;
    end

    max = countSkills.max;
    bestFit = [];
    (0...(countSkills.length)).each do |i|
      if countSkills[i] == max
        bestFit.push(i)
      end
    end

    return bestFit

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :url, :company)
    end

    # To get all the movies of the database
    def set_skills
      @skills = Skill.all
    end
end
