module SizzleRig::Arduino
  class Serial
    include Singleton
    
    def initialize
      puts "DEVICE PATH NOT SET" if ENV["DEVICE_PATH"].nil?
      @device = ENV["DEVICE_PATH"] || "/dev/tty.usbmodem1411"
      @io = ::IO.popen("minicom -b 9600 -D #{@device}", 'w+')
    end
    
    def rotate(percentage)
      raise ArgumentError, "Percentage must be between 0.0 and 1.0" unless percentage > 0.0 && percentage <= 1.0
      
      @io.puts percentage.to_s
    end
  end
end