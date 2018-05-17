class ChangeGamesTable < ActiveRecord::Migration[5.1]
  def change
    remove_column  :games, :winner
    remove_column  :games, :player_1_api_key
    remove_column  :games, :player_2_api_key
    change_table :games do |t|
      t.belongs_to :player_1, foreign_key: { to_table: :users}
      t.belongs_to :player_2, foreign_key: { to_table: :users}
      t.belongs_to :winner, foreign_key: { to_table: :users}
    end
  end
end
