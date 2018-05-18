class AddShipsToSpaces < ActiveRecord::Migration[5.1]
  def change
    change_table :spaces do |t|
      t.references :ship, foreign_key: true
    end
  end
end
