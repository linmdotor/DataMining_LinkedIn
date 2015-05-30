module ApplicationHelper
  #If no specific title is given on a certain page, the "base_title" is shown on top of the page instead.
  #Use this to provide a specific title in the 'views' scripts: <% provide(:title, "Home") %>
  def full_title(page_title = '')
    base_title = "Mining LinkedIn"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end