class NcCharterSchools::CLI
  def call
    puts "Welcome to NC Charter Schools CLI App!"
    puts NcCharterSchools::Scraper.scrape_name
  end
  
end