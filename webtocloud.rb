# coding: utf-8

#A function that will take the results given from webcrawlerfunc and storing them in the cloud with MongoLab.

#Gems that are required
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'json'
gem 'mongo', '=1.9.2'
require 'mongo'

#Other ruby files that are required
require_relative 'webcrawlerfunc'
require_relative 'AlsoViewed'

#What company are you interested in?
#Asks the user for input
puts
puts "What company are you interested in? "
insert_company = gets.chomp
puts

#Where do most of the company employees reside?
#Asks the user for input, could maybe be automated by finding out with a robot where the company resides.
puts "Where do most of the company employees reside? "
country = gets.chomp
puts

#Call webcrawlerfunc and get the hash of persons of interest (poi)
poi_tot, total_time1, total_time2 = webcrawlerfunc(insert_company, country)

#To test,use poi_tot below instead of that one above.
# It only calls the AlsoViewed-function, to reduce results but still have some significant amount of data.
#poi_tot = AlsoViewed(insert_company, 'https://se.linkedin.com/pub/william-hed%C3%A9n/86/734/b52')

#Time to connect to the MongoLab-server
puts "Adding your data to the MongoLab database. I can see the finish line now!"
beginning_time = Time.now

#Use your credentials created specifically for the linkedin_project database.
dbuser = "pwheden"
dbpassword = "2.5liter/dagLAB"
#dbuser = "username"
#dbpassword = "password"

#Standard URI format: mongodb://[dbuser:dbpassword@]host:port/dbname
begin
	uri = "mongodb://#{dbuser}:#{dbpassword}@ds039211.mongolab.com:39211/linkedin_project"
	client = Mongo::MongoClient.from_uri(uri)
rescue
	puts "Your server might be sleeping. Did you try to awake it? (Connection failure)"
end
db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
db = client.db(db_name)

#Add a collection
folder_companyname = db.collection("#{insert_company.tr(" ", "_")}")
#Add data to the collection
poi_tot.keys.each do |key|
	folder_companyname.insert(poi_tot[key])
end

#Close the MongoLab-server
client.close()

end_time = Time.now
total_time3 = end_time - beginning_time
total_time = total_time1 + total_time2 + total_time3
puts "Added to your database in #{total_time3} seconds."
puts
puts "Finished the job in #{total_time} seconds. Go have a look at your results!"
