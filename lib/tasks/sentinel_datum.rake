require 'open-uri'
require 'csv'
require 'net/ftp'
require 'httparty'

MAX_DATA_POINTS = 200000
HTTP_URL = "http://sentinel.ga.gov.au/geoserver-historic/sentinel/wfs?service=WFS&version=1.1.0&request=GetFeature&typeName=sentinel%3Ahotspot_historic&outputFormat=json&maxFeatures=#{MAX_DATA_POINTS}&CQL_FILTER="
START_TIME_QUERY_PREFIX = '%20IS%20NOT%20null%20AND%20datetime%20BETWEEN%20'
END_TIME_QUERY_PREFIX = '%20AND%20'

namespace :data do
  desc "Seed Sentinel data via HTTP"
  task seed_sentinel: :environment do
    getHTTPData
  end
end

def getHTTPData
  years = Array(2002..2016)
  months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
  total = 0
  errors = 0

  years.each do |y|
    puts y
    months.each do |m|
      url = "#{HTTP_URL}australian_state#{START_TIME_QUERY_PREFIX}#{y}-#{m}-01T00%3A00%3A00#{END_TIME_QUERY_PREFIX}#{y}-#{m}-31T23%3A59%3A59"
      resp = HTTParty.get(url)
      json = JSON.parse(resp.body)

      features = json['features']
      features.each do |f|
        createSentinelDatum(f)
      end

      puts m
      puts "Datapoint count: #{features.count}"
    end
  end

  puts "Total Data Points: #{total}"
  puts "Errors: #{errors}"

end

def createSentinelDatum(feature)
  hash = Hash.new
  props = feature['properties']

  hash['hotspot_id'] = feature['id']
  hash['sentinel_id'] = props['id']
  hash['longitude'] = props['longitude']
  hash['latitude'] = props['latitude']
  hash['temp_kelvin'] = props['temp_kelvin']
  hash['datetime'] = props['datetime']
  hash['power'] = props['power']
  hash['confidence'] = props['confidence']
  hash['australian_state'] = props['australian_state'].strip

  begin
    s = SentinelDatum.create!(hash)
    total += 1
  rescue => e
    puts e.message
    errors += 1
  end
end
