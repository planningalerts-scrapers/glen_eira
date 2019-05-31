require "epathway_scraper"

scraper = EpathwayScraper.scrape_and_save(
  "https://epathway-web.gleneira.vic.gov.au/ePathway/Production",
  list_type: :all, max_pages: 4
)
