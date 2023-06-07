class IngredientMeal < ApplicationRecord
  self.table_name = 'ingredients_meals'

  ### ASSOCIATIONS ###

  belongs_to :ingredient
  belongs_to :meal

  ### VALIDATIONS ###

  validates :ingredient_quantity, presence: true
  validates :ingredient_quantity, numericality: {greater_than: 0}, allow_nil: true
  validates :meal_id, uniqueness: { scope: :ingredient_id }

  ### CALLBACKS ###

  after_commit :set_meal_price, if: proc { |im| (!im.persisted? || im.ingredient_quantity_previously_changed?) && im.meal.persisted? }
  after_commit :set_meal_non_veg, if: proc { |im| (!im.persisted? || im.ingredient_id_previously_changed?) && im.meal.persisted?}

  def price
    ingredient.price_per_portion * ingredient_quantity
  end

  private def set_meal_price
    meal.set_price
  end

  private def set_meal_non_veg
    meal.set_non_veg
  end
end
