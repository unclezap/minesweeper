class Game < ApplicationRecord
    belongs_to :board
    # accepts_nested_attributes_for :boards

    def generate_ref_array()
        ref_array = []
        
        self.board.num_mines.times do
            ref_array.push(9)
        end
        
        (self.board.height * self.board.width - self.board.num_mines).times do
            ref_array.push(0)
        end

        return ref_array
    end

    def self.generate_game_state(game)
        height = game.board.height
        width = game.board.width
        mines = game.board.num_mines
        seed = game.board.seed
        ref_array = game.generate_ref_array()
        ref_array = ref_array.shuffle(random: Random.new(seed))
        binding.pry


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

        binding.pry
        game.board_state =  game_state
        game.save
    end
end
