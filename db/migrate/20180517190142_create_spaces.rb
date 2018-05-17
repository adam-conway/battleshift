class CreateSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :status

      t.references :board, foreign_key: true
    end
  end
end
