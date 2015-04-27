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
	page = agent.get('https://se.linkedin.com/in/cristiannorlin')

	#page = agent.get("#{urlpage}")

	page.links.each do |link|
	  L.push(link.uri.to_s())
	end
	L = L.uniq

	N = Hash.new
	N[Insert_Company] = {}
	for link in L 
		if link.include? "pub"
			#a,b = NameSkills( Insert_Company, link)
			hash_name, hash_skills = NameSkills(Insert_Company, link)
			#puts a,b
			if (hash_name.empty? == false && hash_skills.empty? == false)
 				N[Insert_Company][hash_name] = {'Skills'=>hash_skills,'LinkedIn URL'=>link}
 			end

		end
	end
	return N
end
