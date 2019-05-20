require "epathway_scraper"

scraper = EpathwayScraper::Scraper.new(
  "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP"
)

page = scraper.pick_type_of_search(:all)

# Only scrape the most recent 4 pages, not the entire database
number_pages = 4
(1..number_pages).each do |no|
  url = "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquirySummaryView.aspx?PageNumber=#{no}"
  page = scraper.agent.get(url)
  puts "Scraping page #{no} of " + number_pages.to_s + "..."
  scraper.scrape_index_page(page) do |record|
    EpathwayScraper.save(record)
  end
end
