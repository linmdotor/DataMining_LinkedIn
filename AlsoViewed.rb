# function for upgrading the web crawler: this funtion clicks on the "people also viewed" links on a certain
# Linked in profile.

def AlsoViewed(insert_company, urlpage)

	require 'rubygems'
	require 'mechanize'
	require 'nokogiri'
	require 'open-uri'
	require 'json'

	require_relative 'NameSkills'

	#Initialize Mechanize
	agent = Mechanize.new
	agent.user_agent_alias = "Mac Safari"
	agent.follow_meta_refresh = true
	
	L = []
	Insert_Company = "Ericsson"
	page = agent.get('https://se.linkedin.com/in/cristiannorlin') # goes to the LinkedIn of a user

	#page = agent.get("#{urlpage}")

	page.links.each do |link|
	  L.push(link.uri.to_s()) #pushes all links on the page to a list
	end
	L = L.uniq

	N = Hash.new
	N[Insert_Company] = {}
	for link in L 
		if link.include? "pub" #takes only the links which will redirect to a new profile
			#a,b = NameSkills( Insert_Company, link)
			hash_name, hash_skills = NameSkills(Insert_Company, link) #call the function Nameskills which checks if the desired company is among the experience
			#puts a,b
			if (hash_name.empty? == false && hash_skills.empty? == false)
 				N[Insert_Company][hash_name] = {'Skills'=>hash_skills,'LinkedIn URL'=>link} #hashes the skills, the link to a dictionary, the name
 			end

		end
	end
	return N
end
