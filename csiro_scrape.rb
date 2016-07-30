#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'csv'
require 'net/ftp'
require 'colorize'
require 'httparty'

BASE_URL = 'ftp://ftp.ga.gov.au/outgoing-emergency-imagery/sentinel/'

def scrape

  uri = URI.parse(BASE_URL)
  out_dir = './temp'
  Dir.mkdir(out_dir) unless Dir.exists?(out_dir)
  dirs = ['AVHRR', 'hotspots', 'MODIS', 'VIIRS']

  dirs.each do |d|
    file_list = []
    begin
      Net::FTP.open(uri.host) do |ftp|
        ftp.login
        ftp.chdir(uri.path + d)
        file_list << ftp.list('*hotspots.txt')
      end
    rescue Exception => e
      puts "Exception: '#{e}'. FTP Failed."
      return
    end

    p file_list

    path = "#{uri}#{d}"
    open(path) { |f|
      if (f.basename.includes?('hotpots.txt'))
        File.open("#{out_dir}/#{f.basename}.csv", 'w') do |o|
            o.write(f)
        end
      end
    }
  end
end

def processFile(file)
end

def getData
  source_dir = './datasets'
  out_dir = './temp'
  Dir.mkdir(out_dir) unless Dir.exists?(out_dir)
  dirs = ['AVHRR', 'hotspots', 'MODIS', 'VIIRS']

  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  dirs.each do |d|
    Dir.glob(File.join("#{source_dir}/#{d}/*hotspots.txt")).each do |f|
      csv = CSV.new(File.open(f), :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
      p csv.to_a.map {|row| row.to_hash }
    end
  end

end

getData
