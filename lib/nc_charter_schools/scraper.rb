class NcCharterSchools::Scraper
  
 # Scraping data on charter schools managed by North Carolina Department of Public Instruction
  def self.doc
    @@doc ||= Nokogiri::HTML(open("http://apps.schools.nc.gov/ords/f?p=125:1100"))
  end
  
  def self.scrape_name      
    @@name ||= doc.css("td.t15Body a").map {|name| name.text}
  end

end