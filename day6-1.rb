#!/usr/bin/env ruby

races = []

File.open('day6.txt', 'r') do |f|
    times = []
    f.readline.split(' ').drop(1).each { |length| times << length.to_i }
    f.readline.split(' ').drop(1).each do |record| 
        races << {
            :time => times.shift,
            :record => record.to_i
        }
    end
end

options_per_race = []
races.each do |race|
    winning_options = 0
    (1 .. race[:time] - 1).each do |hold|
        movement_time = race[:time] - hold
        winning_options += 1 if hold * movement_time > race[:record]
    end
    options_per_race << winning_options
end

puts options_per_race.inject(:*)
