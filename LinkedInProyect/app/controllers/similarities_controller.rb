class SimilaritiesController < ApplicationController

  def index
    @similarity = Similarity.new
  end

  def create
    company = params[:similarity][:company].downcase
    id = params[:similarity][:id]

    sim_skills company
    sim_empl company, id
    render :output
  end

  def output
    company = params[:company]
    id = params[:id]

    sim_skills company
    sim_empl company, id
  end

  def sim_skills company

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
      @top3 << Skill.where(:_id => indexSort[i][0])
    end

  end


  def sim_empl company, id

    comp = Company.where(:name => company).pluck(:_id)[0].to_s
    allEmp = User.where(:company_id => comp).pluck(:name, :skill_ids).to_a
    myUser = User.where(:_id => id).pluck(:skill_ids).to_a

    countSkills = Array.new(allEmp.length) {0};

    myUser[0].each do |skill|
      (0...(allEmp.length)).each do |i|
        if allEmp[i][1].include?(skill)
          countSkills[i] += 1;
        end
      end
    end

    division = countSkills

    (0...(countSkills.length)).each do |i|
      puts "***************"
      puts allEmp[i][0]
      puts countSkills[i] / (myUser[0].length + allEmp[i][1].length  - division[i]).to_f;
      countSkills[i] /= (myUser[0].length + allEmp[i][1].length - division[i]).to_f;
    end

    puts countSkills.max

    max = countSkills.max;
    bestFit = [];
    (0...(countSkills.length)).each do |i|
      if countSkills[i] == max
        bestFit.push(i)
      end
    end

    @theBest = User.where(:name => allEmp[bestFit[0]][0])

    @theSkills = []
    (0...(allEmp[bestFit[0]][1].length)).each do |i|
      @theSkills << Skill.where(:_id => allEmp[bestFit[0]][1][i])
    end

  end


end
