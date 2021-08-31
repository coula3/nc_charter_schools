class NcCharterSchools::Scraper
  
 # Scraping data on charter schools managed by North Carolina Department of Public Instruction
  def self.doc
    @@doc ||= Nokogiri::HTML(open("http://apps.schools.nc.gov/ords/f?p=125:1100"))
  end
  
  def self.data_load
    data_load ||= doc.css("td.apex_report_break")
  end

  def self.scrape_name
    @@name ||= data_load.map do |name|
      name.children.text.lstrip.scan(/[a-zA-Z\W\s]+(?=Charter Code)/)
    end.flatten
  end
  
  def self.scrape_url
    @@url ||= data_load.map do |data|
      data.children
    end.map do |data|
      data[2].name == "a" ? data[2].attribute("href").value : nil
    end
  end

  def self.scrape_charter_code
    @@charter_code ||= data_load.map {|code| code.children.text.scan(/(?<=Code:.)\S{3}/)}.flatten
  end

  def self.scrape_city_state
    @@city_state ||= data_load.map do |cs|
      cs.children.text.scan(/(?<=\n)[a-zA-Z\s\W]+\s\NC\s\d+/)
    end.flatten
  end

  def self.scrape_county
    @@county ||= data_load.map do |data|
      data.children.text.scan(/(?<=County: )[a-zA-Z\s]+\n/).join.gsub(/\n/, "").strip
    end
  end

  def self.scrape_telephone
    @@telephone ||= data_load.map {|tel| tel.children.text.scan(/Phone:\s\d+\.\d+\d.\d+/).join.gsub("Phone: ", "")}
  end

  def self.scrape_effective_date
    @@effective_date ||= data_load.map {|date| date.children.text.scan(/(?<=Date:.)\S{10}/)}.flatten.map {|date| date.gsub("/", "-")}
  end

  def self.scrape_grade
    @@grade ||= doc.css("tr.highlight-row").map {|grade| grade.children[3].text}
  end
    
  # Scraping data on NC counties from website of North Carolina Association of County Commissioners
  def self.county_doc
    @@county_doc ||= Nokogiri::HTML(open("https://www.ncacc.org/171/Links-to-Counties"))
  end

  def self.scrape_nc_county
    @@nc_counties ||= county_doc.css("div.map-select option").select do |v|
      v.attributes.size == 3
    end.map { |c| c.children.text }
  end
end