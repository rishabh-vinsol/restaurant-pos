class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :mode, default: 0
      t.string :stripe_session_id

      t.timestamps
    end
  end
end
