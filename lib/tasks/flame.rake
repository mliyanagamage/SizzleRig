YEAR_RANGE = Array(2007..2016)

namespace :flame do
  desc "Flame Story Nation Wide"
  task :story => :environment do
    total_points = SentinelDatum.count
    avg_power = SentinelDatum.pluck(:power).reject(&:nil?).reduce(:+) / total_points

    fire_values = []

    YEAR_RANGE.each do |y|
      start_time = Date.new(y).to_time
      end_time = start_time.end_of_year.to_time

      year_count = SentinelDatum.where(datetime: start_time..end_time).count
      year_avg_power = SentinelDatum.where(datetime: start_time..end_time).pluck(:power).reject(&:nil?).reduce(:+)

      if year_avg_power.present?
        year_avg_power /= year_count

        fire_value = year_avg_power / avg_power
      else
        fire_value = 0.01
      end

      avg_data_points = year_count / total_points

      fire_values << (fire_value + avg_data_points)
      puts "Year: #{y}, Power: #{fire_value}" 
    end

    max_val = fire_values.max

    fire_values = fire_values.map { |f| f / max_val }

    puts "Final Values: "
    fire_values.each_with_index do |f, i|
      puts "Year: #{YEAR_RANGE[i]} = #{f}"
    end

    do_fire(fire_values)
  end

  desc "Frame Story State Wide"
  task :state_story => :environment do
    state = ENV["STATE"] || "ACT"

    state = state.upcase

    unless ["NT", "SA", "QLD", "NSW", "WA", "VIC", "TAS", "ACT"].include?(state)
      raise ArgumentError, "Invalid State"
    end

    total_points = SentinelDatum.count
    avg_power = SentinelDatum.pluck(:power).reject(&:nil?).reduce(:+) / total_points

    fire_values = []

    YEAR_RANGE.each do |y|
      start_time = Date.new(y).to_time
      end_time = start_time.end_of_year.to_time

      year_count = SentinelDatum.where(datetime: start_time..end_time).count
      year_avg_power = SentinelDatum.where(datetime: start_time..end_time).pluck(:power).reject(&:nil?).reduce(:+)

      if year_avg_power.present?
        year_avg_power /= year_count

        fire_value = year_avg_power / avg_power
      else
        fire_value = 0.01
      end

      avg_data_points = year_count / total_points

      fire_values << (fire_value + avg_data_points)
      puts "Year: #{y}, Power: #{fire_value}" 
    end

    max_val = fire_values.max

    fire_values = fire_values.map { |f| f / max_val }

    puts "Final Values: "
    fire_values.each_with_index do |f, i|
      puts "Year: #{YEAR_RANGE[i]} = #{f}"
    end

    do_fire(fire_values)
  end
end

def do_fire(values)
  values.each_with_index do |f, i|
    "Moving for #{YEAR_RANGE[i]}"
    SizzleRig::Arduino::Serial.instance.rotate(f.to_f)
  end
end

# entire story, first to last
# for given date, nation wide thread level
# state based thread level for a date
# store for state based

# 