class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :pincode
      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
