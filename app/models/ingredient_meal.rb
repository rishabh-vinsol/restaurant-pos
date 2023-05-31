class IngredientMeal < ApplicationRecord
  self.table_name = 'ingredients_meals'

  ### ASSOCIATIONS ###

  belongs_to :ingredient
  belongs_to :meal

  ### VALIDATIONS ###

  validates :ingredient_quantity, presence: true

  ### CALLBACKS ###

  after_commit :set_meal_price
  after_commit :set_meal_non_veg

  private def set_meal_price
    meal.set_price if !persisted? || ingredient_quantity_previously_changed?
  end

  private def set_meal_non_veg
    meal.set_non_veg if !persisted? || ingredient_id_previously_changed?
  end
end