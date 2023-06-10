class IngredientMeal < ApplicationRecord
  self.table_name = 'ingredients_meals'

  ### ASSOCIATIONS ###

  belongs_to :ingredient
  belongs_to :meal
  has_many :branches_meals, through: :meal
  has_many :inventories, through: :ingredient

  ### VALIDATIONS ###

  validates :ingredient_quantity, presence: true
  validates :ingredient_quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :meal_id, uniqueness: { scope: :ingredient_id }

  ### CALLBACKS ###

  after_commit :set_meal_price, if: proc { |im| (!im.persisted? || im.ingredient_quantity_previously_changed?) && im.meal.persisted? }
  after_commit :set_meal_non_veg, if: proc { |im| (!im.persisted? || im.ingredient_id_previously_changed?) && im.meal.persisted? }
  after_commit :reset_branch_meal_availability

  def price
    ingredient.price_per_portion * ingredient_quantity
  end

  def update_inventory(branch_id, order_quantity, inc)
    inventories.where(branch_id: branch_id).each { |i| i.update_quantity(ingredient_quantity * order_quantity, inc) }
  end

  private def set_meal_price
    meal.set_price
  end

  private def set_meal_non_veg
    meal.set_non_veg
  end

  private def reset_branch_meal_availability
    branches_meals.each(&:update_available)
  end
end
