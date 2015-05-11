class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  # GET /skills
  # GET /skills.json
  def index
    @skills = Skill.all
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
    @skill = Skill.find(params[:id])
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
    @skill = Skill.find(params[:id])
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to skills_path, notice: 'Skill was successfully created.' }
        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.html { redirect_to skills_path, notice: 'Skill was successfully updated.' }
        format.json { render :show, status: :ok, location: @skill }
      else
        format.html { render :edit }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to skills_path, notice: 'Skill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def simSkills

    company = params[:company]

    comp = Company.where(:name => company.to_s).pluck(:_id)[0].to_s
    empl = User.where(:company_id => comp).pluck(:name, :skill_ids).to_a

    skills = [];
    occurences = [];

    (0...(empl.length)).each do |i|
      (0...(empl[i][1].to_a.length)).each do |j|
        unless skills.include?(empl[i][1].to_a[j])
          skills.push(empl[i][1].to_a[j]);
          occurences.push(1);
        else
          occurences[skills.index(empl[i][1].to_a[j])] += 1;
        end
      end
    end

    total = 0;
    (0...(occurences.length)).each do |i|
      total += occurences[i]
    end

    index = Array.new(skills.length);
    (0...(index.length)).each do |i|
      index[i] = [skills[i], occurences[i].to_f/total];
    end

    indexSort = index.sort_by{|s,n| n }.reverse;
    @top3 = [];

    (0..2).each do |i|
      @top3 << Skill.where(:_id => indexSort[i][0].to_s)
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skill_params
      params.require(:skill).permit(:name)
    end
end
