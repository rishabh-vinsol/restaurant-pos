class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.integer :quantity, default: 0
      t.references :branch, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.index [:ingredient_id, :branch_id], unique: true

      t.timestamps
    end
  end
end
