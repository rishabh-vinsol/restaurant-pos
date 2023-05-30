class IngredientMeal < ApplicationRecord
  self.table_name = 'ingredients_meals'

  ### ASSOCIATIONS ###

  belongs_to :ingredient
  belongs_to :meal

  ### VALIDATIONS ###

  validates :ingredient_quantity, presence: true

  ### CALLBACKS ###

  after_commit :set_meal_price

  private def set_meal_price
    meal.set_price if !persisted? || ingredient_quantity_previously_changed?
  end
end