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

	#--------------------#
	#A test link+company to avoid using all the data. Comment out 'page = ..'' below and use this instead when testing.
	#page = agent.get('https://se.linkedin.com/pub/william-hedén/86/734/b52')
	#insert_company = 'Ericsson'
	#--------------------#

	#Tell Mechanize to enter this URL.
	page = agent.get("#{urlpage}")

	#Go through the person's linkedin page and recover their name+skills if they belong to the company we are searching for.
	#Initialize constants
	name = ""
	skills = []

	#Since we check for the company and skills separately, we need a boolean to tell us if we should save the skills
	#we have found or not. boolean is set = 1 if the company is found among the user's experience.
	boolean = 0
	li_company_name = []

	#If 'insert_company' exists among the experience, the person's profile is of interest
	page.links.each do |link|
		link_text = link.uri.to_s()
		if link_text.include? "company"
			#Save the name of the link - which will be LinkedIn specific instead of the user-types "insert_company"
			#We will save all of the companies the person has worked for - can be useful later.
			if link.to_s.empty? == false
				li_company_name.push(link.to_s())
				if link.to_s.include? insert_company
					name = page.title
					#page.title includes some bogus, use a slice function to get just the name
					name = name.slice(0..(name.index('|'))-2)
					boolean = 1
				elsif insert_company.include? link.to_s
					name = page.title
					#page.title includes some bogus, use a slice function to get just the name
					name = name.slice(0..(name.index('|'))-2)
					boolean = 1
				end
			end
		end
		#All skills on a LI-page appear as links, and their url has the keyword 'topic'
		#look for these links and store their name which is the skill of the person.
		if link_text.include? "topic"
			#Again, some formatting to get just the name of the skill and no additional trash
			page_skill = link_text.slice((link_text.index('topic'))+6..(link_text.index('?'))-1)
			if page_skill.empty? == false
				skills.push(page_skill)
			end
		end
	end

	#Remove duplicates
	skills = skills.uniq
	li_company_name = li_company_name.uniq

	#If boolean == 0, which means the company was not enocuntered among the person's experience,
	#don't return anything.
	if boolean == 0
		name = ""
		skills = []
		li_company_name = []
	end
	#If boolean == 1, return name+skills+name_of_the_linkedin_company_link!
	return name, skills, li_company_name
end