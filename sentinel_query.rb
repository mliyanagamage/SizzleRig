#!/usr/bin/env ruby

require 'httparty'

BASE_URL = 'http://sentinel.ga.gov.au/geoserver-historic/sentinel/wfs?service=WFS&version=1.1.0&request=GetFeature&typeName=sentinel%3Ahotspot_historic&outputFormat=json&maxFeatures=1000&CQL_FILTER='
START_TIME_QUERY_PREFIX = '%20IS%20NOT%20null%20AND%20datetime%20BETWEEN%20'
END_TIME_QUERY_PREFIX = '%20AND%20'

def getData
  years = Array(2002..2016)
  months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

  years.each do |y|
    months.each do |m|
      url = "#{BASE_URL}australian_state#{START_TIME_QUERY_PREFIX}#{y}-#{m}-01T00%3A00%3A00#{END_TIME_QUERY_PREFIX}#{y}-#{m}-31T23%3A59%3A59"
      resp = HTTParty.get(url)
      json = JSON.parse(resp.body)
      p json['features'][0]
    end
  end
end

getData
