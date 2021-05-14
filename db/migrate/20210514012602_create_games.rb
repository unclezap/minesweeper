class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.boolean :won_game
      t.integer :board_id
      t.hstore :board_state

      t.timestamps
    end
  end
end
