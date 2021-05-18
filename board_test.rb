require 'benchmark'

class Game
    def self.generate_ref_array(height, width, mines)
        ref_array = []
        
        mines.times do
            ref_array.push(9)
        end
        
        (height * width - mines).times do
            ref_array.push(0)
        end

        return ref_array
    end

    # def self.generate_game_state_correct(height, width, mines, ref_array)

    def self.click(y_pos, x_pos, width, game_state) 
    # def convert_coord_to_arr(y_pos, x_pos) {
    #     return y_pos * self.board.width + x_pos
        tile = y_pos * width + x_pos
        puts tile

        if game_state[tile][:num] == 9
            game_state[tile][:uncovered] = true
            return "game over"
        end

        return self.uncover([tile], game_state)
    end

    # def click(position) {
    def self.uncover(tiles, game_state) 
        if tiles.empty?
            return game_state
        end

        to_uncover_arr = []

        tiles.each do |tile|
            game_state[tile][:uncovered] = true

            if game_state[tile][:num] == 0
                game_state[tile][:linked_tiles].each do |linked_tile|
                    if game_state[linked_tile][:num] != 9 && !game_state[linked_tile][:uncovered]
                       to_uncover_arr.push(linked_tile) 
                    end
                end
            end
        end

        uncover(to_uncover_arr, game_state)
    end

        # puts ref_array
    def self.generate_game_state(height, width, mines)

        # seed = self.board.seed
        # seed = Random.new_seed
        seed = 3
        ref_array = self.generate_ref_array(height, width, mines).shuffle(random: Random.new(seed))
        # puts "hash bois"
        pp ref_array

        game_state = {}

        count_hash = {
            0 => 0,
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 1
        }

        area = height * width
    
            #top left corner
        game_state[0] = {
            :linked_tiles => [1,width],
            :uncovered => false
        }
        if ref_array[0] == 9
            game_state[0][:num] = 9
        else
            game_state[0][:num] = count_hash[ref_array[1]] + count_hash[ref_array[width]] + count_hash[ref_array[width+1]]
        end

            #top right corner
        game_state[width - 1] = {
            :linked_tiles => [width - 2, 2*width - 1],
            :uncovered => false
        }
        if ref_array[width - 1] == 9
            game_state[width - 1][:num] = 9
        else
            game_state[width - 1][:num] = count_hash[ref_array[width - 2]] + count_hash[ref_array[2*width - 1]] + count_hash[ref_array[2*width - 2]]
        end

            #bottom right corner
        game_state[width * height - 1] = {
            :linked_tiles => [width*height - 2, width*(height - 1) - 1],
            :uncovered => false
        }
        if ref_array[-1] == 9
            game_state[width * height - 1][:num] = 9
        else
            game_state[width*height - 1][:num] = count_hash[ref_array[-2]] + count_hash[ref_array[width*(height - 1) - 1]] + count_hash[ref_array[width*(height - 1) - 2]]
        end

            #bottom right corner
        game_state[width*(height - 1)] = {
            #need some logic to deal with 1x or x1 boards
            :linked_tiles => [width*(height - 1) + 1, width*(height - 2)],
            :uncovered => false
        }
        if ref_array[width*(height - 1)] == 9
            game_state[width*(height - 1)][:num] = 9
        else
            game_state[width*(height - 1)][:num] = count_hash[ref_array[width*(height - 2)]] + count_hash[ref_array[width*(height - 2) + 1]] + count_hash[ref_array[width*(height - 1) + 1]]
        end

        #top and bottom edges
        if width > 2
            index = 1
            top_column1 = count_hash[ref_array[index - 1]] + count_hash[ref_array[index - 1 + width]]
            top_column2 = count_hash[ref_array[index]] + count_hash[ref_array[index + width]]
            top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

            bottom_column1 = count_hash[ref_array[area - index - 2]] + count_hash[ref_array[area - index - 2 - width]]
            bottom_column2 = count_hash[ref_array[area - index - 1]] + count_hash[ref_array[area - index - width - 1]]
            bottom_column3 = count_hash[ref_array[area - index]] + count_hash[ref_array[area - index - width]]

            (width - 2).times do
                #top edge
                game_state[index] = {
                    :linked_tiles => [index - 1, index + 1, index + width],
                    :uncovered => false
                }
                if ref_array[index] == 9
                    game_state[index][:num] = 9
                else
                    game_state[index][:num] = top_column1 + top_column2 + top_column3
                end

                #bottom edge
                bottom_tile = area - 1 - index
                game_state[bottom_tile] = {
                    :linked_tiles => [bottom_tile + 1, bottom_tile - 1, bottom_tile - width],
                    :uncovered => false
                }
                if ref_array[bottom_tile] == 9
                    game_state[bottom_tile][:num] = 9
                else
                    game_state[bottom_tile][:num] = bottom_column1 + bottom_column2 + bottom_column3
                end

                index += 1

                if index < width - 1
                    top_column1 = top_column2
                    top_column2 = top_column3
                    top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

                    bottom_column3 = bottom_column2
                    bottom_column2 = bottom_column1
                    bottom_column1 = count_hash[ref_array[area - index - 2]] + count_hash[ref_array[area - index - 2 - width]]
                end
            end
        end

        # sides
        if height > 2
            row = 1

            left_row1 = count_hash[ref_array[(row - 1)*width]] + count_hash[ref_array[(row - 1)*width + 1]]
            left_row2 = count_hash[ref_array[(row*width)]] + count_hash[ref_array[row*width + 1]]
            left_row3 = count_hash[ref_array[(row+1)*width]] + count_hash[ref_array[(row+1)*width + 1]]

            right_row1 = count_hash[ref_array[row*width - 1]] + count_hash[ref_array[row*width - 2]]
            right_row2 = count_hash[ref_array[(row+1)*width - 1]] + count_hash[ref_array[(row+1)*width - 2]]
            right_row3 = count_hash[ref_array[(row+2)*width - 1]] + count_hash[ref_array[(row+2)*width - 2]]
            
            (height - 2).times do
                left_tile = row*width
                right_tile = (row + 1)*width - 1

                #left edge
                game_state[left_tile] = {
                    :linked_tiles => [left_tile - width, left_tile + 1, left_tile + width],
                    :uncovered => false
                }
                if ref_array[left_tile] == 9
                    game_state[left_tile][:num] = 9
                else
                    game_state[left_tile][:num] = left_row1 + left_row2 + left_row3
                end

                #right edge
                game_state[right_tile] = {
                    :linked_tiles => [right_tile - width, right_tile - 1, right_tile + width],
                    :uncovered => false
                }
                if ref_array[right_tile] == 9
                    game_state[right_tile][:num] = 9
                else
                    game_state[right_tile][:num] = right_row1 + right_row2 + right_row3
                end

                row += 1

                if row < height - 1
                    left_row1 = left_row2
                    left_row2 = left_row3
                    left_row3 = count_hash[ref_array[left_tile + 2*width]] + count_hash[ref_array[left_tile + 2*width + 1]]

                    right_row1 = right_row2
                    right_row2 = right_row3
                    right_row3 = count_hash[ref_array[right_tile + 2*width - 1]] + count_hash[ref_array[right_tile + 2*width - 2]]
                end
            end
        end
    
        # inner tiles
        if height > 2 && width > 2
            row = 1

            (height - 2).times do
                column = 1
                position = row*width + column

                column1 = count_hash[ref_array[position - width - 1]] + count_hash[ref_array[position - 1]] + count_hash[ref_array[position + width - 1]]
                column2 = count_hash[ref_array[position - width]] + count_hash[ref_array[position]] + count_hash[ref_array[position + width]]
                column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]

                (width - 2).times do
                    game_state[position] = {
                        :linked_tiles => [position - width, position - 1, position + 1, position + width],
                        :uncovered => false
                    }

                    if ref_array[position] == 9
                        game_state[position][:num] = 9
                    else
                        game_state[position][:num] = column1 + column2 + column3
                    end

                    column += 1
                    position = row*width + column

                    if column < width - 1
                        column1 = column2
                        column2 = column3
                        column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]
                    end
                end
                row += 1
            end
        end

        return game_state
    end

    def self.generate_hash_nums(height, width, mines)
        seed = Random.new_seed
        # seed = 3
        ref_array = self.generate_ref_array(height, width, mines).shuffle(random: Random.new(seed))
        # puts "hash bois"
        # pp ref_array

        game_state = {}

        count_hash = {
            0 => 0,
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 1
        }

        area = height * width
    
            #top left corner
        if ref_array[0] == 9
            game_state[0] = {:num => 9}
        else
            game_state[0] = {:num => count_hash[ref_array[1]] + count_hash[ref_array[width]] + count_hash[ref_array[width+1]]}
        end

            #top right corner
        if ref_array[width - 1] == 9
            game_state[width - 1] = {:num => 9}
        else
            game_state[width - 1] = {:num => count_hash[ref_array[width - 2]] + count_hash[ref_array[2*width - 1]] + count_hash[ref_array[2*width - 2]]}
        end

            #bottom right corner
        if ref_array[-1] == 9
            game_state[width * height - 1] = {:num => 9}
        else
            game_state[width*height - 1] = {:num => count_hash[ref_array[-2]] + count_hash[ref_array[width*(height - 1) - 1]] + count_hash[ref_array[width*(height - 1) - 2]]}
        end

            #bottom right corner
        if ref_array[width*(height - 1)] == 9
            game_state[width*(height - 1)] = {:num => 9}
        else
            game_state[width*(height - 1)] = {:num => count_hash[ref_array[width*(height - 2)]] + count_hash[ref_array[width*(height - 2) + 1]] + count_hash[ref_array[width*(height - 1) + 1]]}
        end

        #top and bottom edges
        if width > 2
            index = 1
            top_column1 = count_hash[ref_array[index - 1]] + count_hash[ref_array[index - 1 + width]]
            top_column2 = count_hash[ref_array[index]] + count_hash[ref_array[index + width]]
            top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

            bottom_column1 = count_hash[ref_array[area - index - 2]] + count_hash[ref_array[area - index - 2 - width]]
            bottom_column2 = count_hash[ref_array[area - index - 1]] + count_hash[ref_array[area - index - width - 1]]
            bottom_column3 = count_hash[ref_array[area - index]] + count_hash[ref_array[area - index - width]]

            (width - 2).times do
                #top edge
                if ref_array[index] == 9
                    game_state[index] = {:num => 9}
                else
                    game_state[index] = {:num => top_column1 + top_column2 + top_column3}
                end

                #bottom edge
                bottom_tile = area - 1 - index
                if ref_array[bottom_tile] == 9
                    game_state[bottom_tile] = {:num => 9}
                else
                    game_state[bottom_tile] = {:num => bottom_column1 + bottom_column2 + bottom_column3}
                end

                index += 1

                if index < width - 1
                    top_column1 = top_column2
                    top_column2 = top_column3
                    top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

                    bottom_column3 = bottom_column2
                    bottom_column2 = bottom_column1
                    bottom_column1 = count_hash[ref_array[area - index - 2]] + count_hash[ref_array[area - index - 2 - width]]
                end
            end
        end

        # sides
        if height > 2
            row = 1

            left_row1 = count_hash[ref_array[(row - 1)*width]] + count_hash[ref_array[(row - 1)*width + 1]]
            left_row2 = count_hash[ref_array[(row*width)]] + count_hash[ref_array[row*width + 1]]
            left_row3 = count_hash[ref_array[(row+1)*width]] + count_hash[ref_array[(row+1)*width + 1]]

            right_row1 = count_hash[ref_array[row*width - 1]] + count_hash[ref_array[row*width - 2]]
            right_row2 = count_hash[ref_array[(row+1)*width - 1]] + count_hash[ref_array[(row+1)*width - 2]]
            right_row3 = count_hash[ref_array[(row+2)*width - 1]] + count_hash[ref_array[(row+2)*width - 2]]
            
            (height - 2).times do
                left_tile = row*width
                right_tile = (row + 1)*width - 1

                #left edge
                if ref_array[left_tile] == 9
                    game_state[left_tile] = {:num => 9}
                else
                    game_state[left_tile] = {:num => left_row1 + left_row2 + left_row3}
                end

                #right edge
                if ref_array[right_tile] == 9
                    game_state[right_tile] = {:num => 9}
                else
                    game_state[right_tile] = {:num => right_row1 + right_row2 + right_row3}
                end

                row += 1

                if row < height - 1
                    left_row1 = left_row2
                    left_row2 = left_row3
                    left_row3 = count_hash[ref_array[left_tile + 2*width]] + count_hash[ref_array[left_tile + 2*width + 1]]

                    right_row1 = right_row2
                    right_row2 = right_row3
                    right_row3 = count_hash[ref_array[right_tile + 2*width - 1]] + count_hash[ref_array[right_tile + 2*width - 2]]
                end
            end
        end
    
        # inner tiles
        if height > 2 && width > 2
            row = 1

            (height - 2).times do
                column = 1
                position = row*width + column

                column1 = count_hash[ref_array[position - width - 1]] + count_hash[ref_array[position - 1]] + count_hash[ref_array[position + width - 1]]
                column2 = count_hash[ref_array[position - width]] + count_hash[ref_array[position]] + count_hash[ref_array[position + width]]
                column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]

                (width - 2).times do
                    if ref_array[position] == 9
                        game_state[position] = {:num => 9}
                    else
                        game_state[position] = {:num => column1 + column2 + column3}
                    end

                    column += 1
                    position = row*width + column

                    if column < width - 1
                        column1 = column2
                        column2 = column3
                        column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]
                    end
                end
                row += 1
            end
        end

        return game_state
    end
end

class GameGenerator
    def self.board_generator_show_random_seed(width, length, mines)
        seed = Random.new_seed
        ref_array = self.ref_array_generator_nine(width, length, mines).shuffle(random: Random.new(seed))
        # ref_array = self.ref_array_generator_nine(width, length, mines).shuffle(random: Random.new(seed))
        # puts "arr bois"
        # pp ref_array
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.shift(),0])
                row += 1
            else
                board[row].insert(-2,ref_array.shift())
            end
            count += 1
        end

        border = [0,0]
        length.times do
            border.push(0)
        end
        board.unshift(border)
        board.push(border)

        board = self.border_slicer(self.tile_number_generator_nine(board, width, length))

        # pp board
        # return [board, seed]
        return board
    end

    def self.ref_array_generator_nine(width, length, mines)
        ref_array = []
        
        mines.times do
            ref_array.push(9)
        end
        
        (width * length - mines).times do
            ref_array.push(0)
        end

        return ref_array
    end

    def self.tile_number_generator_nine(board, width, length)
        count_hash = {
            0 => 0,
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 1
        }

        y_pos = 1
        width.times do
            x_pos = 0

            column1 = count_hash[board[y_pos-1][x_pos-1]] + count_hash[board[y_pos][x_pos-1]] + count_hash[board[y_pos+1][x_pos-1]]
            column2 = count_hash[board[y_pos-1][x_pos]] + count_hash[board[y_pos][x_pos]] + count_hash[board[y_pos+1][x_pos]]
            column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]
            
            length.times do
                x_pos += 1

                column1 = column2
                column2 = column3
                column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]
                if board[y_pos][x_pos] != 9
                    board[y_pos][x_pos] = column1 + column2 + column3
                end
            end
            y_pos += 1
        end

        return board
    end

    def self.border_slicer(board)
        board.pop()
        board.shift()

        row = 0
        while row < board.length do
            board[row].pop()
            board[row].shift()
            row += 1
        end

        return board
    end
end

# pp GameGenerator.board_generator_show_random_seed(4,6,6)

game_state = Game.generate_game_state(4,6,4)
pp game_state
# y = Game.generate_hash_nums(4,6,6)

# pp game_state

# i = 0
# while i < 24
#     if x[i][:num] != y[i][:num]
#         puts i
#     end
#     i += 1
# end

i = 0
while i < 24
    puts "#{i}: #{game_state[i][:num]}"
    i += 1
end

puts '========='

pp Game.click(3,0,6, game_state)

i = 0
while i<24
    if game_state[i][:uncovered]
        puts i
    end
    i += 1
end
# pp Game.generate_game_state(3,2,2,GameGenerator.board_generator_show_random_seed(3,2,2)[1])


# Benchmark.bm do |benchmark|

#     benchmark.report("10 times reg") do
#         10.times do
#             GameGenerator.board_generator_show_random_seed(16,30,99)
#         end
#     end

#     benchmark.report("10 times hash crystal") do
#         10.times do
#             Game.generate_game_state(16,30,99)
#         end
#     end

#     benchmark.report("10 times just hash") do
#         10.times do
#             Game.generate_hash_nums(16,30,99)
#         end
#     end

#     puts '==============='

#     benchmark.report("30k times reg") do
#         30000.times do
#             GameGenerator.board_generator_show_random_seed(16,30,99)
#         end
#     end

#     benchmark.report("30k hash crystal") do
#         30000.times do
#             Game.generate_game_state(16,30,99)
#         end
#     end

#     benchmark.report("30k just hash") do
#         30000.times do
#             Game.generate_hash_nums(16,30,99)
#         end
#     end

#     puts '==============='

#     benchmark.report("30k times, double size board reg") do
#         30000.times do
#             GameGenerator.board_generator_show_random_seed(32,30,198)
#         end
#     end

#     benchmark.report("30k times, double size board hash crystal") do
#         30000.times do
#             Game.generate_game_state(32,30,198)
#         end
#     end

#     benchmark.report("30k times, double size board just hash") do
#         30000.times do
#             Game.generate_hash_nums(32,30,198)
#         end
#     end

#     puts '==============='

#     benchmark.report("30k times, 4x board reg") do
#         30000.times do
#             GameGenerator.board_generator_show_random_seed(64,30,396)
#         end
#     end

#     benchmark.report("30k times, 4x board hash crystal") do
#         30000.times do
#             Game.generate_game_state(64,30,396)
#         end
#     end

#     benchmark.report("30k times, 4x board just hash") do
#         30000.times do
#             Game.generate_hash_nums(64,30,396)
#         end
#     end
# end