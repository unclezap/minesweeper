class AddSeedToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :seed, :integer
  end
end
