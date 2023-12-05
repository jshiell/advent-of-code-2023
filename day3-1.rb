#!/usr/bin/env ruby

part_numbers = []

def is_symbol?(char)
    unless char.nil?
        char.match?(/[^.\d]/)
    else
        false 
    end
end

def filter_number(schematic, number, start, x, y)
    start_index = [0, start - 1].max
    end_index = [x, schematic[y].length - 1].min
    symbol = (start_index..end_index).inject(false) { |memo, index| memo || is_symbol?((schematic[y - 1] || [])[index]) }  if y - 1 > 0
    symbol ||= [start_index, end_index].inject(false) { |memo, index| memo || is_symbol?(schematic[y][index]) } 
    symbol ||= (start_index..end_index).inject(false) { |memo, index| memo || is_symbol?((schematic[y + 1] || [])[index]) } if y + 1 < schematic.length 

    number.to_i if symbol
end

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
                    part_numbers << filter_number(schematic, number, start, x, y)
                    start = nil
                    number = ''
                end
            end
        end
        
        part_numbers << filter_number(schematic, number, start, line.length - 1, y) unless number.empty?
    end
end

puts part_numbers.select {|n| !n.nil? }.inject(&:+)
