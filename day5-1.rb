#!/usr/bin/env ruby

mapping_sets = {}
seeds = []

def map_value(mapping_set, from)
    mapping_set.inject(nil) do |memo, mapping|
        unless memo
            if from >= mapping[:from] && from < mapping[:from] + mapping[:offset]
                memo = mapping[:to] + (from - mapping[:from])
            end
        end
        memo
    end || from
end

File.open('day5.txt', 'r') do |f|
    map_name = nil
    mappings = []

    f.each_line do |line|
        if line.chomp.empty?
            unless map_name.nil?
                mapping_sets[map_name.chomp] = mappings
                map_name = nil
                mappings = []
            end
        elsif line.match?(/^\d/)
            match = line.match(/^(\d+)\s+(\d+)\s+(\d+)$/)
            mappings << {
                to: match[1].to_i,
                from: match[2].to_i,
                offset: match[3].to_i
            }
        elsif line.match?(/^seeds:/)
            match = line.match(/^seeds:\s+(.*)$/)
            seeds = match[1].chomp.split(' ').map(&:to_i)
        elsif line.match(/map:$/)
            map_name = line.match(/^(.*) map:/)[1]
        end
    end
    unless map_name.nil?
        mapping_sets[map_name.chomp] = mappings
        map_name = nil
        mappings = []
    end
end

locations = []
seeds.each do |seed|
    soil = map_value(mapping_sets['seed-to-soil'], seed) 
    fertiliser = map_value(mapping_sets['soil-to-fertilizer'], soil)
    water = map_value(mapping_sets['fertilizer-to-water'], fertiliser)
    light = map_value(mapping_sets['water-to-light'], water)
    temp = map_value(mapping_sets['light-to-temperature'], light)
    humidity = map_value(mapping_sets['temperature-to-humidity'], temp)
    locations << map_value(mapping_sets['humidity-to-location'], humidity)
end

puts locations.min
