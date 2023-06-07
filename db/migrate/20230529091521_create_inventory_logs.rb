class CreateInventoryLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :inventory, null: false, foreign_key: true
      t.integer :quantity_changed
      t.text :comment

      t.timestamps
    end
  end
end
