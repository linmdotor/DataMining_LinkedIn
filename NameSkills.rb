#This function takes as input the "Insert_Company" from webcrawler2.rb and a URL "page" and returns a hash element with Name+Skills

def NameSkills(insert_company, urlpage)
	require 'rubygems'
	require 'mechanize'
	require 'nokogiri'
	require 'open-uri'
	require 'json'

	agent = Mechanize.new
	agent.user_agent_alias = "Mac Safari"
	agent.follow_meta_refresh = true
	#page = agent.get('https://www.linkedin.com/pub/bianca-partanen-dufour/42/572/aba?trk=pub-pbmap')
	page = agent.get("#{urlpage}")

	name = ""
	p = []
	page.links.each do |link|
			if link.text.include? "#{insert_company}"
				name = page.title
				name = name.slice(0..(name.index('|'))-2)
				page.links.each do |link|
					a = link.uri.to_s()
					if a.include? "topic"
						p.push(a.slice((a.index('topic'))+6..(a.index('?'))-1))
					end
	  			end
			end
		end
	p = p.uniq
	return name, p
end
