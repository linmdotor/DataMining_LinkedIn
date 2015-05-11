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
	#page = agent.get('https://www.linkedin.com/pub/bianca-partanen-dufour/42/572/aba?trk=pub-pbmap')
	page = agent.get("#{urlpage}")

	#Go through the person's linkedin page and recover their name+skills if they belong to the company we are searching for.
	name = ""
	p = []
	boolean = 0

	page.links.each do |link|
		if link.text.include? "#{insert_company}"
			name = page.title
			name = name.slice(0..(name.index('|'))-2)
			boolean = 1
		end
		a = link.uri.to_s()
		if a.include? "topic"
			p.push(a.slice((a.index('topic'))+6..(a.index('?'))-1))
		end
	end

	p = p.uniq
	if boolean == 0
		name = ""
		p = []
	end
	return name, p
end
