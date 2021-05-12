json.extract! board, :id, :width, :height, :num_mines, :name, :url, :email_id, :created_at, :updated_at
json.url board_url(board, format: :json)
