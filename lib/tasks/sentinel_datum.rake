require 'open-uri'
require 'csv'
require 'net/ftp'

SENTINEL_URL = 'ftp://ftp.ga.gov.au/outgoing-emergency-imagery/sentinel/'

namespace :data do
  desc "Seed latest Sentinel data"
  task seed_sentinel: :environment do
    paths = getFilePaths
    getData(paths)
  end
end

def getFilePaths
  uri = URI.parse(SENTINEL_URL)
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
          path = SENTINEL_URL + d + '/' + name[0]
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

def getData(paths)
  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  paths.each do |path|
    open(path) { |f|
      csv = CSV.new(f, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
      csv.to_a.map {|row| SentinelDatum.create(row.to_hash)}
    }
  end

end
