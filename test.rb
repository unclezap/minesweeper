y_pos = 1
x_pos = 1
Infinity = 1.0/0

board = [[0,0,0],[0,Infinity,6],[0,0,0]]

count_hash = {
    0 => 0,
    Infinity => 1
}


# # count_hash = {}
# # count_hash['B'] = 500

# spot = board[1][0]
# puts spot
# puts spot.class
# puts count_hash['B']
# puts count_hash[spot]
# # puts count_hash.fetch(spot)

# x = count_hash[:spot]
# if x > 1000
#     puts "greater than 1k"
# end

# if x < 1000
#     puts "less than 1l"
# end

# column1 = count_hash[board[y_pos-1][x_pos-1]] + count_hash[board[y_pos][x_pos-1]] + count_hash[board[y_pos+1][x_pos-1]]
column2 = count_hash[board[y_pos-1][x_pos]] + count_hash[board[y_pos][x_pos]] + count_hash[board[y_pos+1][x_pos]]
# column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]

# box_sum = column1 + column2 + column3 - count_hash[board[y_pos][x_pos]]

puts column2
# puts box_sum
# count_hash = {0:0}
# count_hash = {
            # 0: 0,
            # 1: 0,
            # 2: 0,
            # 3: 0,
            # 4: 0,
            # 5: true,
            # 6: 0,
            # 7: 0,
            # 8: 0
            # Infinity: 1
        # }

# if count_hash[4] == 0
#     print "works count hash"
# end

# if count_hash[5]
#     print "works true"
# end


# y_pos = 1
# x_pos = 1

# y_pos -= 1
# x_pos -= 1
# 3.times do
#     3.times do
#         board[y_pos][x_pos] += 1
#         x_pos += 1
#     end
#     x_pos -= 3
#     y_pos += 1
# end
# y_pos -= 2
# x_pos += 1

# puts y_pos
# puts x_pos
# pp board

# [[Infinity, 1]]

# [[]]

# foo = 3

# h = {foo: 7, bar: 1, baz: 2}

# x = h[:foo]
# puts x
# x += 1
# puts x
# # h = {foo: true}

# if !h['foo']
#     print "works"
# end
