#!/usr/bin/env ruby

sum = 0
NUMBERS = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }
R = /^(\d|one|two|three|four|five|six|seven|eight|nine)/


def get_numbers(line)
    numbers_found = []
    match = R.match(line)
    numbers_found << (NUMBERS[match[0].to_sym] || match[0].to_i) if match
    numbers_found.concat(get_numbers(line[1..])) unless line.empty?
    numbers_found.flatten
end

# test data doesn't cover that numbers can overlap
File.open('day1.txt', 'r') do |f|
    f.each_line do |line|
        sum += get_numbers(line).values_at(0, -1).join.to_i
    end
end
puts sum
