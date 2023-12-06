#!/usr/bin/env ruby

points = 0

File.open('day4.txt', 'r') do |f|
    f.each_line do |line|
        matches = line.match(/^Card\s+\d+: ([\d\s]+)\|([\d\s]+)$/)
        
        if matches
            winning_numbers = matches[1].chomp.split(' ').map(&:to_i)
            numbers_you_have = matches[2].chomp.split(' ').map(&:to_i)

            score = 0
            winning_numbers.each do |winning_number|
                if numbers_you_have.include?(winning_number)
                    if score == 0 
                        score = 1
                    else
                        score *= 2
                    end
                end
            end

            points += score
        end
    end
end

puts points
