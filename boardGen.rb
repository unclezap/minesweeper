require 'benchmark'

Infinity = 1.0/0.0

class GameGenerator

    def self.ref_array_generator(width, length, mines)
        ref_array = []
        
        mines.times do
            ref_array.push(Infinity)
        end
        
        (width * length - mines).times do
            ref_array.push(0)
        end

        return ref_array
    end

    def self.box_sum(board,y_pos, x_pos)
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
        
        column1 = count_hash[board[y_pos-1][x_pos-1]] + count_hash[board[y_pos][x_pos-1]] + count_hash[board[y_pos+1][x_pos-1]]
        column2 = count_hash[board[y_pos-1][x_pos]] + count_hash[board[y_pos+1][x_pos]]
        column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]
        
        return column1 + column2 + column3
    end

    def self.tile_number_generator1a(board, width, length)
        
        y_pos = 0
        width.times do
            y_pos += 1
            x_pos = 0
            length.times do
                x_pos += 1
                if board[y_pos][x_pos] != Infinity
                    board[y_pos][x_pos] = self.box_sum(board,y_pos,x_pos)
                end
            end
        end

        return board
    end

    def self.tile_number_generator1aa(board, width, length)
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

        y_pos = 0
        width.times do
            y_pos += 1
            x_pos = 0
            length.times do
                x_pos += 1
                if board[y_pos][x_pos] != Infinity
                    column1 = count_hash[board[y_pos-1][x_pos-1]] + count_hash[board[y_pos][x_pos-1]] + count_hash[board[y_pos+1][x_pos-1]]
                    column2 = count_hash[board[y_pos-1][x_pos]] + count_hash[board[y_pos+1][x_pos]]
                    column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]

                    board[y_pos][x_pos] = column1 + column2 + column3
                end
            end
        end

        return board
    end
    
    def self.tile_number_generator1aab(board, width, length)
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
                    board[y_pos][x_pos] = column1 + column2 + column3 - count_hash[board[y_pos][x_pos]]
                end
            end
            y_pos += 1
        end

        return board
    end

    def self.tile_number_generator1aaa(board, width, length)
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

        y_pos = 0
        width.times do
            y_pos += 1
            x_pos = 0
            length.times do
                x_pos += 1
                if board[y_pos][x_pos] != Infinity
                    sum = 0
                    if board[y_pos-1][x_pos-1] == Infinity
                        sum += 1
                    end
                    if board[y_pos][x_pos-1] == Infinity
                        sum += 1
                    end
                    if board[y_pos+1][x_pos-1] == Infinity
                        sum += 1
                    end
                    if board[y_pos-1][x_pos] == Infinity
                        sum += 1
                    end
                    if board[y_pos+1][x_pos] == Infinity
                        sum += 1
                    end
                    if board[y_pos-1][x_pos+1] == Infinity
                        sum += 1
                    end
                    if board[y_pos][x_pos+1] == Infinity
                        sum += 1
                    end
                    if board[y_pos+1][x_pos+1] == Infinity
                        sum += 1
                    end

                    board[y_pos][x_pos] = sum
                end
            end
        end

        return board
    end

    def self.tile_number_generator1b(board, width, length)
        y_pos = 0

        width.times do
            y_pos += 1
            x_pos = 0
            length.times do
                x_pos += 1
                if board[y_pos][x_pos] == Infinity
                    y_pos -= 1
                    x_pos -= 1
                    3.times do
                        3.times do
                            board[y_pos][x_pos] += 1
                            x_pos += 1
                        end
                        x_pos -= 3
                        y_pos += 1
                    end
                    y_pos -= 2
                    x_pos += 1
                end
            end
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

    #does not include border, should cut
    def self.board_generator1a(width, length, mines)
        
        ref_array = self.ref_array_generator(width, length, mines)
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            rand_tile = ref_array.slice!(rand(area - count))
            if count % length == 0
                board.push([rand_tile])
                row += 1
            else
                board[row].unshift(rand_tile)
            end
            count += 1
        end
        
        return board
    end

    #includes the border
    def self.board_generator1b(width, length, mines)
        
        ref_array = self.ref_array_generator(width, length, mines)
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            rand_tile = ref_array.slice!(rand(area - count))
            if count % length == 0
                board.push([0,rand_tile, 0])
                row += 1
            else
                board[row].insert(1,rand_tile)
            end
            count += 1
        end

        border = [0,0]
        length.times do
            border.push(0)
        end
        board.unshift(border)
        board.push(border)
        
        return board
    end

    def self.board_generator2a(width, length, mines)
        ref_array = self.ref_array_generator(width, length, mines).shuffle
        board = []
        count = 0
        row = -1
        area = width * length

        while count < area do
            if count % length == 0
                board.push([ref_array.pop()])
                row += 1
            else
                board[row].unshift(ref_array.pop())
            end
            count += 1
        end

        return board
    end

    def self.board_generator2b(width, length, mines)
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

        board = self.border_slicer(self.tile_number_generator1b(board, width, length))

        return board
    end

    def self.board_generator2bb(width, length, mines)
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

        board = self.border_slicer(self.tile_number_generator1a(board, width, length))

        return board
    end

    def self.board_generator2bbb(width, length, mines)
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

        board = self.border_slicer(self.tile_number_generator1aa(board, width, length))

        return board
    end

    def self.board_generator2bbb2(width, length, mines)
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

        board = self.border_slicer(self.tile_number_generator1aab(board, width, length))

        return board
    end

    def self.board_generator2bbbb(width, length, mines)
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

        board = self.border_slicer(self.tile_number_generator1aaa(board, width, length))

        return board
    end
end
# puts "======"
# puts "======"
# puts "======"
# pp GameGenerator.board_generator2b(4,4,5)
# puts "~~~~~~~~~"
# pp GameGenerator.board_generator2bb(4,4,5)
# pp GameGenerator.board_generator2bbbb(2,3,3)

# puts Benchmark.measure {
#   50000.times do
#     GameGenerator.board_generator
#   end
# }

pp GameGenerator.board_generator2bbb2(4,6,8)
Benchmark.bm do |benchmark|
    # benchmark.report("Gen 1a") do
    #     10000.times do
    #         GameGenerator.board_generator1a(16,30,99)
    #     end
    # end

    # benchmark.report("Gen 1b") do
    #     10000.times do
    #         GameGenerator.board_generator1b(16,30,99)
    #     end
    # end
  
# Gen 2 is faster and has better Big O time
    # benchmark.report("Gen 2a") do
    #     10000.times do
    #         GameGenerator.board_generator2a(16,30,00)
    #     end
    # end

    # benchmark.report("Gen 2b") do
    #     10000.times do
    #         GameGenerator.board_generator2b(16,30,00)
    #     end
    # end
    benchmark.report("zeb method 10 times") do
        10.times do
            GameGenerator.board_generator2b(16,30,99)
        end
    end

    benchmark.report("box method 10 times") do
        10.times do
            GameGenerator.board_generator2bb(16,30,99)
        end
    end

    benchmark.report("box method no funct call 10 times") do
        10.times do
            GameGenerator.board_generator2bbb(16,30,99)
        end
    end

    benchmark.report("DP method 10 times") do
        10.times do
            GameGenerator.board_generator2bbb2(16,30,99)
        end
    end

    benchmark.report("if method 10 times") do
        10.times do
            GameGenerator.board_generator2bbbb(16,30,99)
        end
    end

    benchmark.report("zeb method") do
        10000.times do
            GameGenerator.board_generator2b(16,30,99)
        end
    end

    benchmark.report("box method") do
        10000.times do
            GameGenerator.board_generator2bb(16,30,99)
        end
    end

    benchmark.report("box method no funct call") do
        10000.times do
            GameGenerator.board_generator2bbb(16,30,99)
        end
    end

    benchmark.report("DP method") do
        10000.times do
            GameGenerator.board_generator2bbb2(16,30,99)
        end
    end

    benchmark.report("if method") do
        10000.times do
            GameGenerator.board_generator2bbb(16,30,99)
        end
    end

    benchmark.report("zeb method x 2") do
        10000.times do
            GameGenerator.board_generator2b(32,30,198)
        end
    end

    benchmark.report("box method x 2") do
        10000.times do
            GameGenerator.board_generator2bb(32,30,198)
        end
    end

    benchmark.report("box method x 2 no funct call") do
        10000.times do
            GameGenerator.board_generator2bbb(32,30,198)
        end
    end

    benchmark.report("DP method x 2") do
        10000.times do
            GameGenerator.board_generator2bbb2(32,30,198)
        end
    end

    benchmark.report("if method x 2") do
        10000.times do
            GameGenerator.board_generator2bbb(32,30,198)
        end
    end
end