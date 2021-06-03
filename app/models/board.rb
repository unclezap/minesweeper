class Board < ApplicationRecord
    belongs_to :email
    has_many :games

    validates_presence_of :name, :message => "You must name your board."
    validate :reasonable_dimensions

    # replace width with height
    # replace length with width
    #Creates an array of tiles with mines randomly distributed that will be transformed into the game board
    #Mines are represented by 9s
    def ref_array_generator
        ref_array = []
            
        self.num_mines.times do
            ref_array.push(9)
        end
            
        (self.height * self.width - self.num_mines).times do
            ref_array.push(0)
        end
    
        return ref_array
    end
    
    #Uses a dynamic programming method to quickly calculate the values for non-mine tiles
    #Creates a 3x3 box around a tile and calculates the number of bombs in each column
    #Each time you go to the next tile the box is shifted over
    def tile_number_generator(board)
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
        self.height.times do
            x_pos = 0
    
            column1 = count_hash[board[y_pos-1][x_pos-1]] + count_hash[board[y_pos][x_pos-1]] + count_hash[board[y_pos+1][x_pos-1]]
            column2 = count_hash[board[y_pos-1][x_pos]] + count_hash[board[y_pos][x_pos]] + count_hash[board[y_pos+1][x_pos]]
            column3 = count_hash[board[y_pos-1][x_pos+1]] + count_hash[board[y_pos][x_pos+1]] + count_hash[board[y_pos+1][x_pos+1]]
                
            self.width.times do
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
    def border_slicer(board)
        board.pop()
        board.shift()
    
        row = 0
        while row < self.height do
            board[row].pop()
            board[row].shift()
            row += 1
        end
    
        return board
    end
    
    #creates a game board based off of the reference array, then calculates tile values and slices off the border
    def board_generator
        ref_array = ref_array_generator().shuffle(random: Random.new(self.seed))
        board = []
        count = 0
        row = -1
        area = self.height * self.width
    
        while count < area do
            if count % self.width == 0
                board.push([0,ref_array.pop(),0])
                row += 1
            else
                board[row].insert(1,ref_array.pop())
            end
            count += 1
        end
    
        border = [0,0]
        self.width.times do
            border.push(0)
        end
        board.unshift(border)
        board.push(border)

        board = border_slicer(tile_number_generator(board))
    
        return board
    end

    private

    def reasonable_dimensions

        if !self.width
            self.errors.add(:width, "You must specify a width.")
        elsif self.width <= 0
            self.errors.add(:width, "Width must be greater than zero.")
        end

        if !self.height
            self.errors.add(:height, "You must specify a height.")
        elsif self.height <= 0
            self.errors.add(:height, "Height must be greater than zero.")
        end

        if !self.num_mines
            self.errors.add(:num_mines, "You must specify a number of mines.")
        else
            if self.num_mines <= 0
                self.errors.add(:num_mines, "You cannot have negative mines.")
            end

            if !!self.width && !!self.height && self.num_mines > self.width * self.height
                self.errors.add(:num_mines, "You cannot have more mines than tiles.")
            end
        end
        
    end
end
