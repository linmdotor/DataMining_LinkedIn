# function for upgrading the web crawler: this funtion clicks on the "people also viewed" links on a certain
# Linked in profile.

def AlsoViewed(insert_company, urlpage)
	#Required gems
	require 'rubygems'
	require 'mechanize'
	require 'nokogiri'
	require 'open-uri'
	require 'json'

	#Other ruby files that are required
	require_relative 'NameSkills'

	#Initialize Mechanize
	agent = Mechanize.new
	#These rows may be unnecessary, remove if it proves problems for Windows/Linux
	agent.user_agent_alias = "Mac Safari"
	agent.follow_meta_refresh = true
	
	l = []
	#A test link to avoid using all the data. Comment out page below and use this instead when testing.
	#insert_company = "Ericsson"
	#page = agent.get('https://se.linkedin.com/in/cristiannorlin') # goes to the LinkedIn of a user
	page = agent.get("#{urlpage}")

	page.links.each do |link|
	  l.push(link.uri.to_s()) #pushes all links on the page to a list
	end
	l = l.uniq

	n = Hash.new
	for link in l 
		if link.include? "pub" #takes only the links which will redirect to a new profile
			hash_name, hash_skills, li_company_name = NameSkills(insert_company, link) #call the function Nameskills which checks if the desired company is among the experience
			if ((hash_name.empty? == false) && (hash_skills.empty? == false))
 				n[hash_name] = {'Name'=>hash_name,'Skills'=>hash_skills,'LinkedIn URL'=>link, 'Company' => li_company_name} #hashes the skills, the link to a dictionary, the name
 			end
		end
	end
	return n
end