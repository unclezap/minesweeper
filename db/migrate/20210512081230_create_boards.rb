class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.integer :width
      t.integer :height
      t.integer :num_mines
      t.string :name
      t.string :url
      t.integer :email_id

      t.timestamps
    end
  end
end
