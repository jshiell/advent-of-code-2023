#!/usr/bin/env ruby

inputs = []

File.open('day9.txt', 'r') do |f|
    f.each_line { |line| inputs << line.chomp.split(' ').map(&:to_i) }
end

extrap = inputs.map do |input|
    history = []

    current = input
    while current.select { |n| n != 0 }.length != 0    
        history << current
        diffs = []
        current.each_with_index do |n, i|
            diffs << current[i + 1] - n if i + 1 < current.length
        end
        current = diffs
    end

    history.map(&:last).sum
end

puts extrap.sum
