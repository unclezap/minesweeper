json.extract! game, :id, :won_game, :board_id, :board_state, :created_at, :updated_at
json.url game_url(game, format: :json)
