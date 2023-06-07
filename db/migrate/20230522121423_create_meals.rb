class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.integer :price, default: 0
      t.boolean :active, default: false
      t.boolean :non_veg, default: false
      t.text :description

      t.timestamps
    end
  end
end
