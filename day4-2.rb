#!/usr/bin/env ruby

cards = 0
instances = {}

File.open('day4.txt', 'r') do |f|
    f.each_line do |line|
        matches = line.match(/^Card\s+(\d+): ([\d\s]+)\|([\d\s]+)$/)
        
        if matches
            card_number = matches[1].to_i
            winning_numbers = matches[2].chomp.split(' ').map(&:to_i)
            numbers_you_have = matches[3].chomp.split(' ').map(&:to_i)

            card_instances = (instances[card_number] || 0) + 1

            score = 0
            winning_numbers.each do |winning_number|
                score += 1 if numbers_you_have.include?(winning_number)
            end

            (1..score).each do |i|
                instances[card_number + i] = (instances[card_number + i] || 0) + card_instances
            end

            cards += card_instances
        end
    end
end

puts cards
