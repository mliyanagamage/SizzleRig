require 'open-uri'
require 'csv'
require 'net/ftp'
require 'httparty'

FTP_URL = 'ftp://ftp.ga.gov.au/outgoing-emergency-imagery/sentinel/'
HTTP_URL = 'http://sentinel.ga.gov.au/geoserver-historic/sentinel/wfs?service=WFS&version=1.1.0&request=GetFeature&typeName=sentinel%3Ahotspot_historic&outputFormat=json&maxFeatures=1000&CQL_FILTER='
START_TIME_QUERY_PREFIX = '%20IS%20NOT%20null%20AND%20datetime%20BETWEEN%20'
END_TIME_QUERY_PREFIX = '%20AND%20'

namespace :data do
  desc "Seed latest Sentinel data"
  task seed_public_sentinel: :environment do
    paths = getFTPFilePaths
    getFTPData(paths)
  end

  desc "Seed Sentinel data from API"
  task seed_api_sentinel: :environment do
    getHTTPData
  end
end

def getFTPFilePaths
  uri = URI.parse(FTP_URL)
  dirs = ['AVHRR', 'hotspots', 'MODIS', 'VIIRS']
  path_list = []

  dirs.each do |d|
    begin
      Net::FTP.open(uri.host) do |ftp|
        ftp.login
        ftp.chdir(uri.path + d)
        lines = ftp.list('*hotspots.txt')

        lines.each do |l|
          name = l.split(" ").delete_if { |w| !w.include?(".txt")}
          path = FTP_URL + d + '/' + name[0]
          p path
          path_list << path
        end
      end
    rescue Exception => e
      puts "Exception: '#{e}'. FTP Failed."
    end
  end

  path_list
end

def getFTPData(paths)
  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  p "Deprecated in migration!"
  # paths.each do |path|
  #   open(path) { |f|
  #     csv = CSV.new(f, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
  #     csv.to_a.map {|row| SentinelDatum.create(row.to_hash)}
  #   }
  # end

end

def getHTTPData
  years = Array(2002..2016)
  months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
  total = 0

  years.each do |y|
    months.each do |m|
      url = "#{HTTP_URL}australian_state#{START_TIME_QUERY_PREFIX}#{y}-#{m}-01T00%3A00%3A00#{END_TIME_QUERY_PREFIX}#{y}-#{m}-31T23%3A59%3A59"
      resp = HTTParty.get(url)
      json = JSON.parse(resp.body)

      features = json['features']
      features.each do |f|
        hash = Hash.new
        props = f['properties']

        hash['sentinel_id'] = props['id']
        hash['longitude'] = props['longitude']
        hash['latitude'] = props['latitude']
        hash['temp_kelvin'] = props['temp_kelvin']
        hash['datetime'] = props['datetime']
        hash['power'] = props['power']
        hash['confidence'] = props['confidence']
        hash['australian_state'] = props['australian_state'].strip

        begin
          s = SentinelDatum.create(hash)
          p "Created sentinel datum at #{s.longitude}, #{s.latitude}"
        rescue ActiveRecord::RecordInvalid => e
            p e.record.error
        end
      end

    end
  end
end
