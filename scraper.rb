require "epathway_scraper"

scraper = EpathwayScraper::Scraper.new(
  "https://epathway-web.gleneira.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP"
)

scraper.scrape(list_type: :all, with_gets: true, max_pages: 4) do |record|
  EpathwayScraper.save(record)
end
