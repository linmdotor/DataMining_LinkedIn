# coding: utf-8

#Testing building a web crawler
#If Mechanize proves difficult installing, it's because there's a bug with Command Line Tools for Xcode 6.3
#Download for 6.2 @ https://developer.apple.com/downloads/index.action#

def webcrawlerfunc(insert_company, country)
	#Gems that are required
	require 'rubygems'
	require 'mechanize'
	require 'nokogiri'
	require 'open-uri'
	require 'json'

	#Other ruby files that are required
	require_relative 'NameSkills'
	require_relative 'AlsoViewed'

	#Initialize Mechanize
	agent = Mechanize.new
	#These rows may be unnecessary, remove if it proves problems for Windows/Linux
	agent.user_agent_alias = "Mac Safari"
	agent.follow_meta_refresh = true

	#Get the suffix so that you search for Google.com/se/es/no depending on the answer in the previous question.
	if country.casecmp("Sweden") == 0 #0 is true
		prefix = "se"
	elsif country.casecmp("Norway") == 0
		prefix = "no"
	elsif country.casecmp("Spain") == 0
		prefix = "es"
	else	
		prefix = "com"
	end

	#Do a Google search of "experience 'Insert_Company' LinkedIn"
	page = agent.get("https://www.google.com/ncr")
	page = agent.get("https://www.google.#{prefix}")
	search_form = page.form('f')
	search_form.q = "experience #{insert_company} LinkedIn"
	page = agent.submit(search_form, search_form.buttons[0])

	#Find all links with "Something | LinkedIn" and put them the names in link_name, and the links in link_url.
	#i is an index telling Mechanize to press the next link on Google named '2', '3' etc.
	#Since we start on the first page, the first link we want to click is '2'.
	i = 2
	link_name = []
	link_url = []

	while i<10 do
		begin
			page.links.each do |link|
		  		if link.text.include? "| LinkedIn"
		  			link_name.push(link.text.slice(0..(link.text.index('|')-1)))
		  			link_url.push("https://www.google.#{prefix}#{link.uri}")
		  		end
			end
		#Scroll through the first 10 Google search pages and continue filling the list L and M.
			if agent.page.links_with(:text => "#{i}")[0] != nil
				page = agent.page.links_with(:text => "#{i}")[0].click
			end
			i += 1
		rescue
			puts "There are no more Google search pages. Skipping to next part."
			i += 1
		end
	end

	#Remove duplicates in link_url to save computational time.
	link_url = link_url.uniq

	#Click each link in link_url, see if the person has experience from 'Insert_Company' and in that case, 
	#save their skills and URL in a hash poi with their name.
	beginning_time = Time.now
	poi = Hash.new
	for i in 0..(link_url.length-1)
		begin
			#Call the function NameSkills.rb with the company name and the URLs in link_url.
		 	hash_name, hash_skills, li_company_name = NameSkills(insert_company, "#{link_url[i]}")
		 	if ((hash_name.empty? == false) && (hash_skills.empty? == false))
		 		#Only save people that have skills visible on LinkedIn to the hash poi.
		 		poi[hash_name] = {'Name'=>hash_name,'Skills'=>hash_skills, 'LinkedIn URL' => link_url[i], 'Company' => li_company_name}
		 	end
		 	#Tell the user how the progress is coming along.
			puts "#{(((i+1)*100)/link_url.length.to_f).round(1)}% completed. Please hold on while we crunch the numbers."
		rescue
			puts "URL: #{link_url[i]} not valid. Skipping to next link."
		end
	end
	end_time = Time.now
	total_time1 = end_time - beginning_time
	#Give an update on the progress.
	puts
	puts "Stage 1 completed in #{total_time1} seconds. Moving to the next stage."
	puts

	#For each person you found in link_url, click all the "People Also Viewed" ONLY for the persons who were put into poi.
	#Send in the links and rerun the NameSkills() function to see if they are persons we want.
	#Store this information in poi_also, we will later combine poi_also and poi. This is to avoid error, maybe we could use just one variable instead.

	#We will run some time tests
	beginning_time = Time.now
	#Index 'i' keep track of the progress in terms of % of loops completed.
	i = 0
	poi_also = Hash.new
	poi.keys.each do |key|
		begin
			#Call the AlsoViewed function with the company name and the URLs in poi.
			a = AlsoViewed(insert_company, poi[key]['LinkedIn URL'])
			poi_also = poi_also.merge(a)
			#Tell the user how the progress is coming along.
			puts "#{(((i+1)*100)/poi.length.to_f).round(1)}% completed. Please hold on while we crunch the numbers."
		rescue
			puts "URL: #{poi[key]['LinkedIn URL']} not valid. Skipping to next link."
		end
		i += 1
	end

	end_time = Time.now
	#Give an update on the progress.
	total_time2 = end_time - beginning_time
	puts
	puts "Stage 2 completed in #{total_time2} seconds. Almost there."
	puts

	#Merge the hashes poi and poi_also, so that all results are in one hash. Store this in the new hash poi_tot, which is given the parent key "company name".
	poi_merge = poi.merge(poi_also)
	
	#poi_tot = Hash.new
	#poi_tot[insert_company] = poi_merge
	poi_tot = poi_merge
	
	return poi_tot, total_time1, total_time2
end