#!/usr/bin/env ruby

race = {}

File.open('day6.txt', 'r') do |f|
    race = {
        :time => f.readline.split(' ').drop(1).join('').to_i,
        :record => f.readline.split(' ').drop(1).join('').to_i
    }
end

winning_options = 0
(1 .. race[:time] - 1).each do |hold|
    movement_time = race[:time] - hold
    winning_options += 1 if hold * movement_time > race[:record]
end
puts winning_options
