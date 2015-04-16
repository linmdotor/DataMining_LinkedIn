#Testing building a web crawler
#If Mechanize proves difficult installing, it's because there's a bug with Command Line Tools for Xcode 6.3
#Download for 6.2 @ https://developer.apple.com/downloads/index.action#

require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'json'

#Initialize Mechanize
agent = Mechanize.new
agent.user_agent_alias = "Mac Safari"
agent.follow_meta_refresh = true

#Sign in to LinkedIn
page = agent.get('https://www.linkedin.com/uas/login')
login_form = page.form('login')
login_form.session_key = 'bigdataminingproject@gmail.com'
login_form.session_password = 'bigdataminingproject123'
page = agent.submit(login_form, login_form.buttons[0])

#What company are you interested in?
Insert_Company = "Kidbrooke Advisory"

#Do a Google search of "LinkedIn 'Insert_Company' Employees"
page = agent.get('https://www.google.com')
search_form = page.form('f')
search_form.q = "LinkedIn #{Insert_Company} Employees"
page = agent.submit(search_form, search_form.buttons[0])

#Click on the link named "'Insert_Company' | LinkedIn"
page = agent.page.links_with(:text => "#{Insert_Company} | LinkedIn")[0].click

#Current URL
next_page = agent.page.uri.to_s

#Find the link that redirects to company employees within the JS code
results = agent.get(next_page).body
s = StringScanner.new(results)
s = s.scan_until /See all/
s = s.lines.last
a = (0 ... s.length).find_all { |i| s[i,1] == '"' }
s = s[a[2]+1..a[3]-1]
next_page = "https://www.linkedin.com/#{s}"
page = agent.get(next_page)

#Find the names of the employees on the first page, later try to expand into going through all pages
#CURRENT WORKING FUNCTION
results = agent.get(next_page).body
puts results
