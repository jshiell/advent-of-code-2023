#!/usr/bin/env ruby

suite = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

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
    groups = card[:hand].sort.group_by { |x| x }
    jokers = (groups['J'] || []).length
    if jokers > 0 && jokers < 5
        high_card = groups.tap { |h| h.delete('J') }.values.sort { |a, b| 
            length = a.length <=> b.length 
            if length == 0
                suite.index(a[0]) <=> suite.index(b[0])
            else
                length
            end
        }.flatten.last
        groups[high_card] = groups[high_card] + ['J'] * jokers
    end
    group_values = groups.tap { |h| h.delete('J') }.values
    card[:type], card[:rank] = if jokers == 5 || group_values.count { |group| group.length == 5 } == 1
        [:five_of_a_kind, 7]
    elsif group_values.count { |g| g.length == 4 } == 1
        [:four_of_a_kind, 6]
    elsif group_values.count { |g| g.length == 3 } == 1 && group_values.count { |g| g.length == 2 } == 1
        [:full_house, 5]
    elsif group_values.count { |g| g.length == 3 } == 1
        [:three_of_a_kind, 4]
    elsif group_values.count { |g| g.length == 2 } == 2
        [:two_pairs, 3]
    elsif group_values.count { |g| g.length == 2 } == 1
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