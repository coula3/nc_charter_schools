class NcCharterSchools::Scraper
  
 # Scraping data on charter schools managed by North Carolina Department of Public Instruction
  def self.doc
    @@doc ||= Nokogiri::HTML(open("http://apps.schools.nc.gov/ords/f?p=125:1100"))
  end
  
  def self.scrape_name
    @@name ||= doc.css("td.t15Body a").map {|name| name.text.lstrip}
  end
  
  def self.scrape_url
    @@url ||= doc.css("td.t15Body a").map {|url| url.attribute("href").value}
  end

  def self.scrape_charter_code
    @@charter_code ||= doc.css("td.apex_report_break").map {|code| code.children.text.scan(/Charter Code:\s\S+/).join.gsub("Charter Code: ", "")}
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
    @@effective_date ||= doc.css("td.apex_report_break").map {|date| date.children.text.scan(/School Effective Date:\s\d+\/\d+\/\d+/).join.gsub("School Effective Date: ","").gsub("/", "-")}
  end

  def self.scrape_grade
    @@grade ||= doc.css("tr.highlight-row").map {|grade| grade.children[3].text}
  end
    
  # Scraping data on NC counties from website of North Carolina Association of County Commissioners
  def self.county_doc
    @@county_doc ||= Nokogiri::HTML(open("https://www.ncacc.org/171/Links-to-Counties"))
  end

  def self.scrape_nc_county
    @@nc_counties ||= county_doc.css("table.telerik-reTable-2 h2.subhead1").map {|c| c.text}.map {|e| e.gsub(/\u00A0|\n/, "")}.map {|e| e.gsub(/[^"]\s[^a-zA-z]/, "")}.map {|e| e.gsub(" County", "")}
  end
end