class Game < ApplicationRecord
    belongs_to :board

    def create_initial_game_state(game_board)
        self.game_state = {}

        row = 0
        column = 0

        game_board.length.times do
            game_board[0].length.times do
                #tiles with a false value are unrevealed
                game_state[[row,column]] = false
                column += 1
            end
            column = 0
            row += 1
        end
        
        return game_state
    end

    def click(game_board,position)
        self.game_state[position] = true
        self.reveal_other_tiles(position)
    end

    def reveal_other_tiles(game_board,position)
        
    end
end
