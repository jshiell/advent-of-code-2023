#!/usr/bin/env ruby

suite = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

directions = []
nodes = {}
File.open('day8.txt', 'r') do |f|
    f.each_line do |line|
        matches = line.match(/(\w{3}) = \((\w{3}), (\w{3})\)/)
        if matches
            nodes[matches[1]] = {
                :name => matches[1],
                'L' => matches[2],
                'R' => matches[3]
            }
        elsif line.chomp.length > 0
            directions = line.chomp.chars
        end
    end
end

steps = 0
current_node = nodes['AAA']

while current_node[:name] != 'ZZZ'
    steps += 1
    next_direction = directions[(steps % directions.length) - 1]
    current_node = nodes[current_node[next_direction]]
end

puts steps
