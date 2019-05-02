require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

def scrape_page(page)
  table = page.at("table.ContentPanel")
  
  table.search("tr")[1..-1].each do |tr|
    day, month, year = tr.search("td")[3].inner_text.split("/").map{|s| s.to_i}
    default_url = "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP"
    
    record = {
      "info_url" => default_url,
      "comment_url" => default_url,
      "council_reference" => tr.at("td a").inner_text,
      "description" => tr.search("td")[1].inner_text,
      "address" => tr.search("td")[2].inner_text,
      "date_received" => Date.new(year, month, day).to_s,
      "date_scraped" => Date.today.to_s
    }

    ScraperWiki.save_sqlite(['council_reference'], record)
  end
end

# Load summary page.
url = "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP"
page = agent.get(url)
form = page.forms.first
form.radiobuttons[0].check
page = form.submit(form.button_with(:value => "Next"))

# Only scrape the most recent 4 pages, not the entire database
number_pages = 4
(1..number_pages).each do |no|
  url = "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquirySummaryView.aspx?PageNumber=#{no}"
  page = agent.get(url)
  puts "Scraping page #{no} of " + number_pages.to_s + "..."
  scrape_page(page)
end
