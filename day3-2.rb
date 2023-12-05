#!/usr/bin/env ruby

def is_gear?(schematic, x, y)
    if (schematic[y] || [])[x] == '*'
        [x, y]
    end
end

def filter_number(gears, schematic, number, start, x, y)
    start_index = [0, start - 1].max
    end_index = [x, schematic[y].length - 1].min
    gear = (start_index..end_index).inject(false) { |memo, index| memo || is_gear?(schematic, index, y - 1) }  if y - 1 > 0
    gear ||= [start_index, end_index].inject(false) { |memo, index| memo || is_gear?(schematic, index, y) } 
    gear ||= (start_index..end_index).inject(false) { |memo, index| memo || is_gear?(schematic, index, y + 1) } if y + 1 < schematic.length 

    gears[gear] = (gears[gear] || []).push(number.to_i) if gear
end

gears = {}

File.open('day3.txt', 'r') do |f|
    schematic = f.readlines.map(&:chomp)
    schematic.each_with_index do |line, y|
        start = nil
        number = ''
        line.chars.each_with_index do |char, x|
            if char.match?(/\d/)
                number += char
                start ||= x
            else
                unless number.empty?
                    filter_number(gears, schematic, number, start, x, y)
                    start = nil
                    number = ''
                end
            end
        end
        
        filter_number(gears, schematic, number, start, line.length - 1, y) unless number.empty?
    end

    puts gears.select {|k, v| v.length > 1 }.values.map {|v| v.inject(&:*) }.inject(&:+)
end
