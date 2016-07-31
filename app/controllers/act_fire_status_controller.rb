class ActFireStatusController < ApplicationController

  def index
    response = HTTParty.get("http://esa.act.gov.au/feeds/firedangerrating.xml")

    xml = Nokogiri::XML(response.body)
    
    @date = xml.xpath("//item//title").children.first.text
    description = xml.xpath("//item//description").children.first.text

    @fire_status = description.split("<br />").first.split(":").last.strip.humanize
    @ban_status = description.split("<br />").last.split(":").last.strip
  end

end
