class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.integer :price
      t.boolean :active
      t.boolean :non_veg
      t.text :description

      t.timestamps
    end
  end
end
