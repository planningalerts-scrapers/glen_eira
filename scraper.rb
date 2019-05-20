require "epathway_scraper"

scraper = EpathwayScraper::Scraper.new(
  "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP"
)

page = scraper.pick_type_of_search(:all)

scraper.scrape_all_index_pages_with_gets(4) do |record|
  EpathwayScraper.save(record)
end
