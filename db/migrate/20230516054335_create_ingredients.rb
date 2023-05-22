class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :price_per_portion
      t.boolean :non_veg
      t.boolean :extra_request

      t.timestamps
    end
  end
end
