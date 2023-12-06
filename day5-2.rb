#!/usr/bin/env ruby

mapping_sets = {}
seeds = []

def map_value(mapping_set, from)
    to_mappings = []

    mapping_set.each do |mapping|
        if from.min >= mapping[:from] && from.min < mapping[:from] + mapping[:offset]
            range_max = mapping[:from] + mapping[:offset]
            if from.max < range_max
                to_mappings << ((mapping[:to] + from.min - mapping[:from])..(mapping[:to] + from.max - mapping[:from]))
            else
                to_mappings << ((mapping[:to] + from.min - mapping[:from])..(mapping[:to] + range_max - 1 - mapping[:from]))
                to_mappings.concat(map_value(mapping_set, (range_max..from.max)))
            end
        end
    end

    if to_mappings.empty?
        [from]
    else 
        to_mappings
    end
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

lowest_location = nil

seeds.each_slice(2) do |seed_from, seed_count|
    soil = map_value(mapping_sets['seed-to-soil'], (seed_from..(seed_from + seed_count)))
    fertiliser = soil.flat_map { |range| map_value(mapping_sets['soil-to-fertilizer'], range) }
    water = fertiliser.flat_map { |range| map_value(mapping_sets['fertilizer-to-water'], range)}
    light = water.flat_map { |range| map_value(mapping_sets['water-to-light'], range)}
    temp = light.flat_map { |range| map_value(mapping_sets['light-to-temperature'], range)}
    humidity = temp.flat_map { |range| map_value(mapping_sets['temperature-to-humidity'], range)}
    location = humidity.flat_map { |range| map_value(mapping_sets['humidity-to-location'], range)}

    lowest_location_range = location.map { |range| range.min }.min
    if lowest_location.nil? || lowest_location_range < lowest_location
        lowest_location = lowest_location_range
    end
end

puts lowest_location
