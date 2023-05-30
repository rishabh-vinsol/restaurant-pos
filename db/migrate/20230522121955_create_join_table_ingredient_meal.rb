class CreateJoinTableIngredientMeal < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients_meals do |t|
      t.references :meal
      t.references :ingredient
      t.integer :ingredient_quantity
      
      t.timestamps
    end
  end
end
