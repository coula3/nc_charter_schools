class NcCharterSchools::Scraper
  
 # Scraping data on charter schools managed by North Carolina Department of Public Instruction
  def self.doc
    @@doc ||= Nokogiri::HTML(open("http://apps.schools.nc.gov/ords/f?p=125:1100"))
  end
  
  def self.scrape_name
    @@name ||= doc.css("td.apex_report_break").map {|name| name.children.text.lstrip.scan(/[a-zA-Z\W\s]+(?=Charter Code)/)}.flatten
  end
  
  def self.scrape_url
    @@url ||= doc.css("td.apex_report_break").map do |data|
      data.children
    end.map do |data|
      data[2].name == "a" ? data[2].attribute("href").value : nil
    end
  end

  def self.scrape_charter_code
    @@charter_code ||= doc.css("td.apex_report_break").map {|code| code.children.text.scan(/(?<=Code:.)\S{3}/)}.flatten
  end

  def self.scrape_city_state
    @@city_state ||= doc.css("td.apex_report_break").map do |cs| 
      city_state_text = cs.children.text.scan(/\w+\s\w+\s\,\s\NC\s\d+|\w+\,\s\NC\s\d+|\w+\s\w+\,\s\NC\s\d+|\w+\-\w+\,\s\NC\s\d+/).join
      sanitized_text = city_state_text.gsub(/\D+\n/, "").gsub("\n", "")
    end.map {|e| e.gsub(/\A\d+/, "")}
  end

  def self.scrape_county
    @@county ||= doc.css("td.apex_report_break").map {|county| county.children.text.scan(/County:\s\w+\s\w+/).join.gsub(/\nSchool/, "").gsub("County: ", "")}
  end

  def self.scrape_telephone
    @@telephone ||= doc.css("td.apex_report_break").map {|tel| tel.children.text.scan(/Phone:\s\d+\.\d+\d.\d+/).join.gsub("Phone: ", "")}
  end

  def self.scrape_effective_date
    @@effective_date ||= doc.css("td.apex_report_break").map {|date| date.children.text.scan(/(?<=Date:.)\S{10}/)}.flatten.map {|date| date.gsub("/", "-")}
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