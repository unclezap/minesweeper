require 'benchmark'

class GameGenerator

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
                    #test if count_hash for center tile can be removed since it wouldn't add in anyway
                    board[y_pos][x_pos] = column1 + column2 + column3 - count_hash[board[y_pos][x_pos]]
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
end

pp GameGenerator.board_generator(1,1,0)
pp GameGenerator.board_generator(1,1,1)
pp GameGenerator.board_generator(2,2,0)
pp GameGenerator.board_generator(2,2,2)
pp GameGenerator.board_generator(2,2,4)
pp GameGenerator.board_generator(2,3,0)
pp GameGenerator.board_generator(2,3,3)
pp GameGenerator.board_generator(2,3,6)
pp GameGenerator.board_generator(4,4,0)
pp GameGenerator.board_generator(4,4,5)
pp GameGenerator.board_generator(4,4,16)
