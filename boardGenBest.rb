require 'benchmark'

puts "==========="
puts "==========="
puts "==========="
puts "==========="

Infinity = 1.0/0.0

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

    #
    def self.generate_game_state_correct(height, width, mines, ref_array)

        puts ref_array
    # def self.generate_game_state_correct(height, width, mines, seed)
        # ref_array = self.generate_ref_array(height, width, mines).shuffle(random: Random.new(seed))

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
    
        game_state[0] = {
            :linked_tiles => [1,width],
            :uncovered => false
        }
        #
        if ref_array[0] == 9
            game_state[0][:num] = 9
        else
            game_state[0][:num] = count_hash[ref_array[1]] + count_hash[ref_array[width]] + count_hash[ref_array[width+1]]
        #
        end
            #top right corner
        game_state[width - 1] = {
            :linked_tiles => [width - 2, 2*width - 1],
            :uncovered => false
        }
        #
        if ref_array[width - 1] == 9
            game_state[width - 1][:num] = 9
        else
            game_state[width - 1][:num] = count_hash[ref_array[width - 1]] + count_hash[ref_array[2*width - 1]] + count_hash[ref_array[2*width - 2]]
        #
        end
            #bottom left corner
        game_state[width * height - 1] = {
            :linked_tiles => [width*height - 2, width*(height - 1) - 1],
            :uncovered => false
        }
        #
        if ref_array[-1] == 9
            game_state[width * height - 1][:num] = 9
        else
            game_state[width*height - 1][:num] = count_hash[ref_array[-2]] + count_hash[ref_array[width*(height - 1) - 1]] + count_hash[ref_array[width*(height - 1) - 2]]
        #
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
        #
        end

        #top and bottom edges
        #
        if width > 2
            index = 1
            top_column1 = count_hash[ref_array[index - 1]] + count_hash[ref_array[index - 1 + width]]
            top_column2 = count_hash[ref_array[index]] + count_hash[ref_array[index + width]]
            top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

            bottom_column1 = count_hash[ref_array[area - index - 2]] + count_hash[ref_array[area - index - 2 - width]]
            bottom_column2 = count_hash[ref_array[area - index - 1]] + count_hash[ref_array[area - index - width - 1]]
            bottom_column3 = count_hash[ref_array[area - index]] + count_hash[ref_array[area - index - width]]

            #
            (width - 2).times do
                #top edge
                game_state[index] = {
                    :linked_tiles => [index - 1, index + 1, index + width],
                    :uncovered => false
                }
                #
                if ref_array[index] == 9
                    game_state[index][:num] = 9
                else
                    game_state[index] = top_column1 + top_column2 + top_column3
                #
                end

                #bottom edge
                bottom_tile = area - 1 - index
                game_state[bottom_tile] = {
                    :linked_tiles => [bottom_tile + 1, bottom_tile - 1, bottom_tile - width],
                    uncovered => false
                }
                #
                if ref_array[bottom_tile] == 9
                    game_state[bottom_tile][:num] = 9
                else
                    game_state[bottom_tile][:num] = bottom_column1 + bottom_column2 + bottom_column3
                #
                end

                index += 1

                top_column1 = top_column2
                top_column2 = top_column3
                top_column3 = count_hash[ref_array[index + 1]] + count_hash[ref_array[index + width + 1]]

                bottom_column3 = bottom_column2
                bottom_column2 = bottom_column1
                bottom_column1 = count_hash[ref_array[bottom_tile - 1]] + count_hash[ref_array[bottom_tile -1 - width]]
            #
            end
        #
        end

        # sides
        if height > 2
            row = 1

            left_row1 = count_hash[ref_array[(row - 1)*width]] + count_hash[ref_array[(row - 1)*width + 1]]
            left_row2 = count_hash[ref_array[(row*width)]] + count_hash[ref_array[row*width + 1]]
            left_row3 = count_hash[ref_array[(row+1)*width]] + count_hash[ref_array[(row+1)*width + 1]]

            right_row1 = count_hash[ref_array[(row - 1)*width - 1]] + count_hash[ref_array[(row - 1)*width - 2]]
            right_row2 = count_hash[ref_array[row*width - 1]] + count_hash[ref_array[row*width - 2]]
            right_row3 = count_hash[ref_array[(row+1)*width - 1]] + count_hash[ref_array[(row+1)*width - 2]]
            
            #
            (height - 2).times do
                tile = row*width

                #left edge
                game_state[tile] = {
                    :linked_tiles => [tile - width, tile + 1, tile + width],
                    :uncovered => false
                }
                #
                if ref_array[tile] == 9
                    game_state[tile][:num] = 9
                else
                    game_state[tile][:num] = left_row1 + left_row2 + left_row3
                #
                end

                #right edge
                #
                if ref_array[tile - 1] == 9
                    game_state[tile - 1][:num] = 9
                else
                    game_state[tile - 1][:num] = right_row1 + right_row2 + right_row3
                #
                end

                row += 1

                left_row1 = left_row2
                left_row2 = left_row3
                left_row3 = count_hash[ref_array[tile + width]] + count_hash[ref_array[tile + width + 1]]

                right_row1 = right_row2
                right_row2 = right_row3
                right_row3 = count_hash[ref_array[tile + width - 1]] + count_hash[ref_array[tile + width - 2]]
            #
            end
        #
        end
    
        # inner tiles
        
        if height > 3 && width > 3
            row = 1

            #
            (height - 2).times do
                column = 1
                position = row*height + column


                column1 = count_hash[ref_array[position - width - 1]] + count_hash[ref_array[position - 1]] + count_hash[ref_array[position + width - 1]]
                column2 = count_hash[ref_array[position - width]] + count_hash[ref_array[position]] + count_hash[ref_array[position + width]]
                column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]

                #
                (width - 2).times do
                    game_state[position] = {
                        :linked_tiles => [position - width - 1, position - width, position - width + 1, position - 1, position + 1, position + width - 1, position + width, position + width + 1],
                        :uncovered => false
                    }

                    if ref_array[position] == 9
                        game_state[position][:num] = 9
                    else
                        game_state[position][:num] = column1 + column2 + column3
                    end

                    column += 1
                    position = row*height + column

                    column1 = column2
                    column2 = column3
                    column3 = count_hash[ref_array[position - width + 1]] + count_hash[ref_array[position + 1]] + count_hash[ref_array[position + width + 1]]
                #
                end
                row += 1
            #
            end
        #
        end

        return game_state
    end

    # def self.generate_game_state(height, width, mines, seed)
    #     ref_array = self.generate_ref_array(height, width, mines).shuffle(random: Random.new(seed))

    #     game_state = {}
    #     ref_array.each do |index|
    #         game_state[index] = true
    #     end

    #     count_hash = {
    #         0 => 0,
    #         1 => 0,
    #         2 => 0,
    #         3 => 0,
    #         4 => 0,
    #         5 => 0,
    #         6 => 0,
    #         7 => 0,
    #         8 => 0,
    #         9 => 1
    #     }

    #     #generate corners
    #         #top left corner
    #     game_state[0] = {
    #         :linked_tiles => [game_state[1],game_state[width]],
    #         :uncovered => false
    #     }
    #     if ref_array[0] == 9
    #         game_state[0][:num] = 9
    #     else
    #         game_state[0][:num] = count_hash[ref_array[1]] + count_hash[ref_array[width]] + count_hash[ref_array[width+1]]
    #     end
    #         #top right corner
    #     game_state[width - 1] = {
    #         :linked_tiles => [game_state[width - 2], game_state[2*width - 1]],
    #         :uncovered => false
    #     }
    #     if ref_array[width - 1] == 9
    #         game_state[width - 1][:num] = 9
    #     else
    #         game_state[width - 1][:num] = count_hash[ref_array[width - 1]] + count_hash[ref_array[2*width - 1]] + count_hash[ref_array[2*width - 2]]
    #     end
    #         #bottom left corner
    #     game_state[width * height - 1] = {
    #         :linked_tiles => [game_state[width*height - 2], game_state[width*(height - 1) - 1]],
    #         :uncovered => false
    #     }
    #     if ref_array[-1] == 9
    #         game_state[width * height - 1][:num] = 9
    #     else
    #         game_state[width*height - 1][:num] = count_hash[ref_array[-2]] + count_hash[ref_array[width*(height - 1) - 1]] + count_hash[ref_array[width*(height - 1) - 2]]
    #     end
    #         #bottom right corner
    #     game_state[width*(height - 1)] = {
    #         :linked_tiles => [game_state[width*(height - 1) + 1], game_state[width*(height - 2)]],
    #         :uncovered => false
    #     }
    #     if ref_array[width*(height - 1)] == 9
    #         game_state[width*(height - 1)][:num] = 9
    #     else
    #         game_state[width*(height - 1)][:num] = count_hash[ref_array[width*(height - 2)]] + count_hash[ref_array[width*(height - 2) + 1]] + count_hash[ref_array[width*(height - 1) + 1]]
    #     end

    #     #generate horizontal edges
    #     if width > 2
    #         column = 1
    #         (width - 2).times do
    #             #top edge
    #             game_state[column] = {
    #                 :linked_tiles => [game_state[column - 1], game_state[column + 1], game_state[column + height]],
    #                 :uncovered => false
    #             }
    #             if ref_array[column] == 9
    #                 game_state[column][:num] = 9
    #             else
    #                 game_state[column][:num] = count_hash[ref_array[column - 1]] + count_hash[ref_array[column + 1]] + count_hash[ref_array[column - 1 + height]] + count_hash[ref_array[column + height]] + count_hash[ref_array[column + height + 1]]
    #             column += 1

    #             #bottom edge
    #             game_state[width * height - 1 - column] = {
    #                 :linked_tiles => [game_state[width * height - column - 2], game_state[width * height - column], game_state[width * height - column - 1 - height]],
    #                 :uncovered => false
    #             }
    #             if ref_array[width * height - 1 - column] == 9
    #                 game_state[width * height - 1 - column][:num] = 9
    #             else
    #                 game_state[width * height - 1 - column][:num] = count_hash[ref_array[width * height - column - 2]] + count_hash[ref_array[width * height - column, width * height - column - 1 - height]] + count_hash[ref_array[width * height - column - height]] + count_hash[ref_array[width * height - column + 1 - height]]
    #             end
            
    #             column += 1
    #         end
    #     end

    #     #generate vertical edges
    #     if height > 2
    #         row = 1
    #         (height - 2).times do
    #             #left edge
    #             game_state[width * row] = {
    #                 :linked_tiles => [game_state[width * (row - 1)], game_state[width * (row + 1)], game_state[width * row + 1]],
    #                 :uncovered => false
    #             }
    #             if ref_array[width * row] == 9
    #                 game_state[width * row][:num] = 9
    #             else
    #                 game_state[width * row][:num] = count_hash[ref_array[width * (row - 1)]] + count_hash[ref_array[width * (row - 1) + 1]] + count_hash[ref_array[width * row + 1]] + count_hash[ref_array[width * (row + 1)]] + count_hash[ref_array[width * (row + 1) + 1]]
    #             end

    #             #right edge
    #             game_state[width * (row + 1) - 1] = {
    #                 :linked_tiles => [game_state[width * row - 1], game_state[width * (row + 1) - 2], game_state[width * (row + 2) - 1]],
    #                 :uncovered => false
    #             }
    #             if ref_array[width * (row + 1) - 1] == 9
    #                 game_state[width * (row + 1) - 1][:num] = 9
    #             else
    #                 game_state[width * (row + 1) - 1][:num] = game_state[ref_array[width * row - 1]] + game_state[ref_array[width * row - 2]] + game_state[ref_array[width * (row + 1) - 2]] + game_state[ref_array[width * (row + 2) - 1]] + game_state[ref_array[width * (row + 2) - 2]]
    #             end

    #             row += 1
    #         end
    #     end



    #     return game_state
    # end
end

# pp Game.generate_game_state(4,4,[9,0,0,0,0,0,9,9,0,0,9,0,0,0,9,0])


class GameGenerator

    def self.board_generator_with_seed(width, length, mines, seed)
        ref_array = self.ref_array_generator_nine(width, length, mines).shuffle(random: Random.new(seed))
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
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

        return board
    end

    def self.board_generator_show_random_seed(width, length, mines)
        seed = Random.new_seed
        puts seed
        ref_array = self.ref_array_generator_nine(width, length, mines).shuffle(random: Random.new(seed))
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
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

        pp board
        return board
    end

    #Creates an array of tiles with mines randomly distributed that will be transformed into the game board
    def self.ref_array_generator(width, length, mines)
        ref_array = []
        
        mines.times do
            ref_array.push('M')
        end
        
        (width * length - mines).times do
            ref_array.push(0)
        end

        return ref_array
    end

    def self.ref_array_generator_inf(width, length, mines)
        ref_array = []
        
        mines.times do
            ref_array.push(Infinity)
        end
        
        (width * length - mines).times do
            ref_array.push(0)
        end

        return ref_array
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

    #Uses a dynamic programming method to quickly calculate the values for non-mine tiles
    #Creates a 3x3 box around a tile and calculates the number of bombs in each column
    #Each time you go to the next tile the box is shifted over
    def self.tile_number_generator(board, width, length)
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
            'M' => 1
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
                if board[y_pos][x_pos] != 'M'
                    board[y_pos][x_pos] = column1 + column2 + column3
                end
            end
            y_pos += 1
        end

        return board
    end

    def self.tile_number_generator_inf(board, width, length)
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
            Infinity => 1
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
                if board[y_pos][x_pos] != Infinity
                    board[y_pos][x_pos] = column1 + column2 + column3
                end
            end
            y_pos += 1
        end

        return board
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

    #board is created with an empty border around it to avoid errors when accessing non-existent array values
    #removing border leaves just the game board values
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

    #creates a game board based off of the reference array, then calculates tile values and slices off the border
    def self.board_generator(width, length, mines)
        ref_array = self.ref_array_generator(width, length, mines).shuffle
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
            end
            count += 1
        end

        border = [0,0]
        length.times do
            border.push(0)
        end
        board.unshift(border)
        board.push(border)

        board = self.border_slicer(self.tile_number_generator(board, width, length))

        return board
    end

    def self.board_generator_inf(width, length, mines)
        ref_array = self.ref_array_generator_inf(width, length, mines).shuffle
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
            end
            count += 1
        end

        border = [0,0]
        length.times do
            border.push(0)
        end
        board.unshift(border)
        board.push(border)

        board = self.border_slicer(self.tile_number_generator_inf(board, width, length))

        return board
    end

    def self.board_generator_nine(width, length, mines)
        ref_array = self.ref_array_generator_nine(width, length, mines).shuffle
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
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

        return board
    end
end

pp Game.generate_game_state_correct(2,2,2,GameGenerator.board_generator_show_random_seed(2, 2, 2))

# pp GameGenerator.board_generator(1,1,0)
# pp GameGenerator.board_generator(1,1,1)
# pp GameGenerator.board_generator(2,2,0)
# pp GameGenerator.board_generator(2,2,2)
# pp GameGenerator.board_generator(2,2,4)
# pp GameGenerator.board_generator(2,3,0)
# pp GameGenerator.board_generator(2,3,3)
# pp GameGenerator.board_generator(2,3,6)
# pp GameGenerator.board_generator(4,4,0)
# pp GameGenerator.board_generator(4,4,5)
# pp GameGenerator.board_generator(4,4,16)

# pp GameGenerator.board_generator_inf(1,1,0)
# pp GameGenerator.board_generator_inf(1,1,1)
# pp GameGenerator.board_generator_inf(2,2,0)
# pp GameGenerator.board_generator_inf(2,2,2)
# pp GameGenerator.board_generator_inf(2,2,4)
# pp GameGenerator.board_generator_inf(2,3,0)
# pp GameGenerator.board_generator_inf(2,3,3)
# pp GameGenerator.board_generator_inf(2,3,6)
# pp GameGenerator.board_generator_inf(4,4,0)
# pp GameGenerator.board_generator_inf(4,4,5)
# pp GameGenerator.board_generator_inf(4,4,16)

# pp GameGenerator.board_generator_nine(1,1,0)
# pp GameGenerator.board_generator_nine(1,1,1)
# pp GameGenerator.board_generator_nine(2,2,0)
# pp GameGenerator.board_generator_nine(2,2,2)
# pp GameGenerator.board_generator_nine(2,2,4)
# pp GameGenerator.board_generator_nine(2,3,0)
# pp GameGenerator.board_generator_nine(2,3,3)
# pp GameGenerator.board_generator_nine(2,3,6)
# pp GameGenerator.board_generator_nine(4,4,0)
# pp GameGenerator.board_generator_nine(4,4,5)
# pp GameGenerator.board_generator_nine(4,4,16)

# pp GameGenerator.board_generator_with_seed(4,4,5,117202443352422133302336407044420046082)
# pp GameGenerator.board_generator_show_random_seed(4,4,5)


# Benchmark.bm do |benchmark|
#     benchmark.report("10 times M") do
#         10.times do
#             GameGenerator.board_generator(16,30,99)
#         end
#     end

#     benchmark.report("10 times Inf") do
#         10.times do
#             GameGenerator.board_generator_inf(16,30,99)
#         end
#     end

#     benchmark.report("10 times 9") do
#         10.times do
#             GameGenerator.board_generator_nine(16,30,99)
#         end
#     end

#     benchmark.report("10k times") do
#         10000.times do
#             GameGenerator.board_generator(16,30,99)
#         end
#     end

#     benchmark.report("10k times Inf") do
#         10000.times do
#             GameGenerator.board_generator_inf(16,30,99)
#         end
#     end

#     benchmark.report("10k times 9") do
#         10000.times do
#             GameGenerator.board_generator_nine(16,30,99)
#         end
#     end

    # benchmark.report("10k times 9") do
    #     10000.times do
    #         GameGenerator.board_generator_nine(2,2,4)
    #     end
    # end

    # benchmark.report("10k hash") do
    #     10000.times do
    #         Game.generate_game_state(2,2,[9,9,9,9])
    #     end
    # end

#     benchmark.report("10k times, double size board") do
#         10000.times do
#             GameGenerator.board_generator(32,30,198)
#         end
#     end

#     benchmark.report("10k times, double size board Inf") do
#         10000.times do
#             GameGenerator.board_generator_inf(32,30,198)
#         end
#     end

#     benchmark.report("10k times, double size board Nine") do
#         10000.times do
#             GameGenerator.board_generator_nine(32,30,198)
#         end
#     end
# end