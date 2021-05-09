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

    def self.board_generator1(width, length, mines)
        
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

    def self.board_generator2(width, length, mines)
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
end



# GameGenerator.board_generator1(16,30,99)
#  GameGenerator.board_generator2(3,4,3)
# pp board

# puts Time.now()
# x = 0
# 1000000000000.times do
#     x += 1
# end
# puts Time.now()


# puts Benchmark.measure {
#   50000.times do
#     GameGenerator.board_generator
#   end
# }

# Benchmark.bm do |benchmark|
#     benchmark.report("Gen 1") do
#         10000.times do
#             GameGenerator.board_generator1(100,100,2000)
#         end
#     end
  
# Gen 2 is faster and has better Big O time
#     benchmark.report("Gen 2") do
#         10000.times do
#             GameGenerator.board_generator2(100,100,2000)
#         end
#     end
# end