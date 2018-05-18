class ChangeBoardsOnGames < ActiveRecord::Migration[5.1]
  def change
    remove_column  :games, :player_1_board
    remove_column  :games, :player_2_board
    change_table :games do |t|
      t.belongs_to :player_1_board, foreign_key: { to_table: :boards}
      t.belongs_to :player_2_board, foreign_key: { to_table: :boards}
    end
  end
end
