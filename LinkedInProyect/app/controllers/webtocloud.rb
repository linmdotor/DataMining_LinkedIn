# # coding: utf-8

# #A function that will take the results given from webcrawlerfunc and storing them in the cloud with MongoLab.

# #Gems that are required
# require 'rubygems'
# require 'mechanize'
# require 'nokogiri'
# require 'open-uri'
# require 'json'
# #gem 'mongo', '=1.9.2'
# require 'mongo'

# #Other ruby files that are required
# require_relative 'webcrawler'
# require_relative 'AlsoViewed'

# #What company are you interested in?
# #Asks the user for input
# puts
# puts "What company are you interested in? "
# insert_company = gets.chomp
# puts

# #Where do most of the company employees reside?
# #Asks the user for input, could maybe be automated by finding out with a robot where the company resides.
# puts "Where do most of the company employees reside? "
# country = gets.chomp
# puts

# #Time to connect to the MongoLab-server
# #Use your credentials created specifically for the linkedin_project database (MongoLab).
# dbuser = "username"
# dbpassword = "password"

# #Time to connect to the MongoLab-server
# #Standard URI format: mongodb://[dbuser:dbpassword@]host:port/dbname
# begin
# 	uri = "mongodb://#{dbuser}:#{dbpassword}@ds039211.mongolab.com:39211/linkedin_project"
# 	client = Mongo::MongoClient.from_uri(uri)
# rescue
# 	puts "Your server might be sleeping. Did you try to awake it? (Connection failure)"
# end
# db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
# db = client.db(db_name)

# boolean = 0
# #Check if the search is already a folder in the DB, in that case we don't need to run the crawler.
# db.collection_names.each do |company|
# 	#Naming collections in MongoLab is hard, it won't take ".", "&", "/" or any weird characters. Transform them!
# 	insert_company = insert_company.tr("ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋ
# 								ÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
# 								"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNn
# 								OOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
# 	#Make search downcase and convert all "/", "." " " to "_" which is how names are represented in MongoLab collections.
# 	if company.downcase == insert_company.downcase.tr("/.& ", "_")
# 		puts "It seems the company you are searching for is already in the database. Do you still want to search for data with a crawler?"
# 		answer = gets.chomp
# 		puts
# 		if answer.downcase == "no"
# 			boolean = 1
# 		end
# 		break
# 	end
# end

# #If the search is not enocuntered, run the webcrawler.
# if boolean == 0
# 	#Call webcrawlerfunc and get the hash of persons of interest (poi)
# 	poi_tot, total_time1, total_time2 = webcrawlerfunc(insert_company, country)
# 	puts "Adding your data to the MongoLab database. I can see the finish line now!"
# 	beginning_time = Time.now

# 	#Add data to the server. For every company a person has worked for - create/join a folder with that name and add the person there
# 	poi_tot.keys.each do |key|
# 		poi_tot[key]["Company"].each do |company|
# 			#Add a collection
# 			company = company.tr("ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋ
# 								ÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
# 								"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNn
# 								OOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
# 			folder_companyname = db.collection("#{company.tr("/.& ", "_")}")
# 			#Add data to the collection
# 			folder_companyname.insert(poi_tot[key])
# 		end
# 	end

# 	end_time = Time.now
# 	total_time3 = end_time - beginning_time
# 	total_time = total_time1 + total_time2 + total_time3
# 	puts "Added to your database in #{total_time3} seconds."
# 	puts
# 	puts "Finished the job in #{total_time} seconds. Go have a look at your results!"
# end

# #Close the MongoLab-server
# client.close()