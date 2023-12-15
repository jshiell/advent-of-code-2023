#!/usr/bin/env ruby

suite = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

cards = []
File.open('day7.txt', 'r') do |f|
    f.each_line do |line|
        parts = line.split(' ')
        cards << {
            :hand => parts[0].chars,
            :bid => parts[1].to_i
        }
    end
end

cards = cards.map do |card|
    groups = card[:hand].sort.group_by { |x| x }.values
    card[:type], card[:rank] = if groups.length == 1
        [:five_of_a_kind, 7]
    elsif groups.length == 2
        if groups[0].length == 4 || groups[1].length == 4
            [:four_of_a_kind, 6]
        else
            [:full_house, 5]
        end
    elsif groups.length == 3
        if groups[0].length == 3 || groups[1].length == 3 || groups[2].length == 3
            [:three_of_a_kind, 4]
        else
            [:two_pairs, 3]
        end
    elsif groups.length == 4
        [:one_pair, 2]
    else
        [:high_card, 1]
    end
    card
end

cards = cards.sort do |a, b|
    if a[:rank] == b[:rank]
        a[:hand].zip(b[:hand]).inject(0) do |memo, (x, y)| 
            if memo != 0
                memo
            else
                suite.index(y) <=> suite.index(x)
            end
        end
    else
        a[:rank] <=> b[:rank]
    end
end

winnings = cards.each_with_index.inject(0) do |memo, (card, i)|
    memo + (card[:bid] * (i + 1))
end
puts winnings