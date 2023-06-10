class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.integer :total, default: 0
      t.string :contact_number
      t.datetime :placed_on
      t.datetime :pickup_time
      t.datetime :picked_up_at

      t.timestamps
    end
  end
end
