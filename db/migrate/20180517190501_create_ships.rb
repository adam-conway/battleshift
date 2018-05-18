class CreateShips < ActiveRecord::Migration[5.1]
  def change
    create_table :ships do |t|
      t.integer :length
      t.integer :damage

      t.timestamps
    end
  end
end
