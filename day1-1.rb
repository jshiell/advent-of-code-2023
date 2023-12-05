#!/usr/bin/env ruby

sum = 0
File.open('day1.txt', 'r') do |f|
    f.each_line do |line|
        sum += line.chars.select { |c| c.match?(/\d/) }.values_at(0, -1).join.to_i
    end
end
puts sum
