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
puts "What company are you interested in? "
insert_company = gets.chomp

#Where do most of the company employees reside?
#Asks the user for input, could maybe be automated by finding out with a robot where the company resides.
puts "Where do most of the company employees reside? "
country = gets.chomp

#Call webcrawlerfunc and get the hash of persons of interest (poi)
poi_tot = webcrawlerfunc(insert_company, country)

#To test,use poi_tot below instead of that one above.
# It only calls the AlsoViewed-function, to reduce results but still have some significant amount of data.
#poi_tot = AlsoViewed(insert_company, 'https://se.linkedin.com/pub/william-hed%C3%A9n/86/734/b52')

#Time to connect to the MongoLab-server
puts "Adding your data to the MongoLab database. I can see the finish line now!"

#Use your credentials created specifically for the linkedin_project database.
dbuser = "username"
dbpassword = "password"

#Standard URI format: mongodb://[dbuser:dbpassword@]host:port/dbname
uri = "mongodb://#{dbuser}:#{dbpassword}@ds039211.mongolab.com:39211/linkedin_project"
client = Mongo::MongoClient.from_uri(uri)
db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
db = client.db(db_name)

#Add a collection
folder_companyname = db.collection("#{insert_company}")
#Add data to the collection
poi_tot.each do |poi|
	folder_companyname.insert(poi)
end

#Close the MongoLab-server
client.close()
