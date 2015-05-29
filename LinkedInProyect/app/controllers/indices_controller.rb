class IndicesController < ApplicationController
	def index
		@index = Index.new
 	end

 	#Call the crawler function
 	def create
 		crawler = WebCrawler.new
 		company = params[:index][:company].downcase
 		country = params[:index][:country].downcase

 		crawler.crawl company, country
 		render :indices #this is the same as "indices"
 	end

 	class WebCrawler
 		#Gems that are required
		require 'rubygems'
		require 'mechanize'
		require 'nokogiri'
		require 'open-uri'
		require 'json'

		#Other ruby files that are required
		#require_relative 'NameSkills'
		#require_relative 'AlsoViewed'
		require_relative 'webcrawler'
		require_relative 'AlsoViewed'

 		def crawl company, country
 			#This is to debug the app, it's displayed on the console
	 		p "**" * 70
	 		p company
	 		p country	

	 		#Initialize Mechanize
			agent = Mechanize.new
			#These rows may be unnecessary, remove if it proves problems for Windows/Linux
			agent.user_agent_alias = "Mac Safari"
			agent.follow_meta_refresh = true

			run_webcrawler = true
			#Check if the company is already in the DB
			db_company = Company.find_by name: company
			p db_company
			if(db_company.present?)
				p "-------------It seems the company you are searching for is already in the database. Do you still want to search for data with a crawler?"
				answer = gets.chomp
				puts
				if answer.downcase == "no" || answer.downcase == "n"
					run_webcrawler = false
				end
			else
				p "-------------NO Existe"
			end


			#If the search is not enocuntered, run the webcrawler.
			if run_webcrawler
				p "VOY A CORRER EL WEBCRAWLER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

				poi_tot, total_time1, total_time2 = webcrawlerfunc(company, country)
				puts "Adding your data to the MongoLab database. I can see the finish line now!"
				beginning_time = Time.now

				puts poi_tot
<<<<<<< HEAD
				puts "***" * 12

				poi_tot.keys.each do |key|
					puts poi_tot[key]["Name"]
					puts poi_tot[key]["Skills"].each do |skill|
						puts skill
					end
					puts poi_tot[key]["LinkedIn URL"]
					poi_tot[key]["Company"]
					puts "***" * 12
				end
=======
>>>>>>> origin/master

				#Add data to the database. THIS MUST BE FILLED
				poi_tot.keys.each do |key|
					#Create the user if Doesn't exist
					user_name = poi_tot[key]["Name"]
					user_url = poi_tot[key]["LinkedIn URL"]

					db_user = User.find_by name: user_name
					if(!db_user.present?) #create the entity
						db_user = User.new(:name => user_name, :url => user_url)
						db_user.save
					end

					#Create the company if Doesn't exist
					if(!db_company.present?) #create the entity
						db_company = Company.new(:name => company)
						db_company.save
					end
<<<<<<< HEAD
					#Add the company to the user
=======

					#Create the skills if Doesn't exist, and add the skills to the user
					my_skills = db_user.skills
					poi_tot[key]["Skills"].each do |skill|
						db_skill = Skill.find_by name: skill
						if(!db_skill.present?) #create the entity
							db_skill = Skill.new(:name => skill)
							db_skill.save
						end

						unless my_skills.include? db_skill
					      db_user.skills << db_skill
					      db_user.save
					    end
					end

					puts "***" * 12

					#Add the company to the user
					db_user.company = db_company
				    db_user.save

>>>>>>> origin/master
				end


				end_time = Time.now
				total_time3 = end_time - beginning_time
				total_time = total_time1 + total_time2 + total_time3
				puts "Added to your database in #{total_time3} seconds."
				puts
				puts "Finished the job in #{total_time} seconds. Go have a look at your results!"
			else
				p "NO SE EJECUTA EL WEBCRAWLER---------------------------"
			end
 		end
 	end
end