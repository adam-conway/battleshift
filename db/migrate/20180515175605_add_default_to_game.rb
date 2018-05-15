class AddDefaultToGame < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :current_turn, :integer, default: 1
  end
end
