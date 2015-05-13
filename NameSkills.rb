#This function takes as input the "Insert_Company" from webcrawler.rb and a URL "urlpage" and returns the name with associated skills of a person.

def NameSkills(insert_company, urlpage)
	#Required gems
	require 'rubygems'
	require 'mechanize'
	require 'nokogiri'
	require 'open-uri'
	require 'json'

	#Initialize Mechanize
	agent = Mechanize.new
	#These rows may be unnecessary, remove if it proves problems for Windows/Linux
	agent.user_agent_alias = "Mac Safari"
	agent.follow_meta_refresh = true
	#A test link to avoid using all the data. Comment out page below and use this instead when testing.
	#page = agent.get('https://se.linkedin.com/pub/william-hedén/86/734/b52')
	#insert_company = 'Ericsson'

	page = agent.get("#{urlpage}")

	#Go through the person's linkedin page and recover their name+skills if they belong to the company we are searching for.
	name = ""
	skills = []

	#Since we check for the company and skills separately, we need a boolean to tell us if we should save the skills
	#we have found or not. boolean is set = 1 if the company is found among the user's experience
	boolean = 0

	#If 'insert_company' exists among the experience, the person's profile is of interest
	page.links.each do |link|
		link_text = link.uri.to_s()
		if link_text.include? "company"
			if ((link.to_s.include? insert_company)  && (link.to_s.empty? == false))
				name = page.title
				#page.title includes some bogus, use a slice function to get just the name
				name = name.slice(0..(name.index('|'))-2)
				boolean = 1
			elsif ((insert_company.include? link.to_s)  && (link.to_s.empty? == false))
				name = page.title
				#page.title includes some bogus, use a slice function to get just the name
				name = name.slice(0..(name.index('|'))-2)
				boolean = 1
			end
		end
		#All skills on a LI-page appear as links, and their url has the keyword 'topic'
		#look for these links and store their name which is the skill of the person
		if link_text.include? "topic"
			#Again, some formatting to get just the name of the skill and no additional trash
			skills.push(link_text.slice((link_text.index('topic'))+6..(link_text.index('?'))-1))
		end
	end

	#Remove duplicates
	skills = skills.uniq

	#If boolean == 0, which means the company was not enocuntered among the person's experience
	#don't return anything
	if boolean == 0
		name = ""
		skills = []
	end
	#If boolean == 1, return name+skills!
	return name, skills
end
