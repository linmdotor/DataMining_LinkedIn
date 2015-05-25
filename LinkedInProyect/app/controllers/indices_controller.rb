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

				#some test printing companies and users
				puts poi_tot
				puts "***" * 12

				poi_tot.keys.each do |key|
					puts poi_tot[key]["Name"]
					puts poi_tot[key]["Skills"].each do |skill|
						puts skill
					end
					puts poi_tot[key]["LinkedIn URL"]
					poi_tot[key]["Company"]
					end
					puts "***" * 12
				end

				#Add data to the database. THIS MUST BE FILLED
				poi_tot.keys.each do |key|
					#Create the user if Doesn't exist
					puts poi_tot[key]["Name"]
					puts poi_tot[key]["LinkedIn URL"]

					#Create the company if Doesn't exist
					poi_tot[key]["Company"]

					#Create the skills if Doesn't exist
					puts poi_tot[key]["Skills"].each do |skill|
						puts skill
					end

					#Add the company to the user



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