#!/usr/bin/env ruby

games = {}
File.open('day2.txt', 'r') do |f|
    f.each_line do |line|
        matches = line.match(/Game (\d+): (.*)/)
        if matches
            id = matches[1].to_i
            games[id] = { r: 0, g: 0, b: 0 }
            matches[2].split(';').each do |game| 
                red = game.match(/(\d+) red/)&.to_a&.dig(1)&.to_i || 0
                blue = game.match(/(\d+) blue/)&.to_a&.dig(1)&.to_i || 0
                green = game.match(/(\d+) green/)&.to_a&.dig(1)&.to_i || 0

                games[id] = {
                    r: red > games[id][:r] ? red : games[id][:r],
                    g: green > games[id][:g] ? green : games[id][:g],
                    b: blue > games[id][:b] ? blue : games[id][:b]
                }
            end
        end
    end
end

puts games.values.map { |game| game[:r] * game[:g] * game[:b] }.inject(&:+)
