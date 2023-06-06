class CreateJoinTableIngredientMeal < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients_meals do |t|
      t.references :meal
      t.references :ingredient
      t.integer :ingredient_quantity, default: 0
      t.index [:meal_id, :ingredient_id], unique: true

      t.timestamps
    end
  end
end
