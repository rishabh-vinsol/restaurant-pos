class IngredientMeal < ApplicationRecord
  self.table_name = 'ingredients_meals'

  ### ASSOCIATIONS ###

  belongs_to :ingredient
  belongs_to :meal
  has_many :branches_meals, through: :meal
  has_many :inventories, through: :ingredient

  ### VALIDATIONS ###

  validates :ingredient_quantity, presence: true
  validates :ingredient_quantity, numericality: {greater_than: 0}, allow_nil: true
  validates :meal_id, uniqueness: { scope: :ingredient_id }

  ### CALLBACKS ###

  after_commit :set_meal_price, if: proc { |im| (!im.persisted? || im.ingredient_quantity_previously_changed?) && im.meal.persisted? }
  after_commit :set_meal_non_veg, if: proc { |im| (!im.persisted? || im.ingredient_id_previously_changed?) && im.meal.persisted?}
  after_save_commit :set_branch_meal_availability
  after_destroy_commit :reset_branch_meal_availability

  def price
    ingredient.price_per_portion * ingredient_quantity
  end

  private def set_meal_price
    meal.set_price
  end

  private def set_meal_non_veg
    meal.set_non_veg
  end

  private def set_branch_meal_availability
    if ingredient_quantity_previously_changed?
      target_branches_meals = branches_meals.joins(:inventories).where('inventories.ingredient_id = ?', ingredient_id)

      if target_branches_meals.blank?
        branches_meals.update_all(available: false)
      else
        target_branches_meals.where('inventories.quantity < ?', ingredient_quantity).update_all(available: false)
        target_branches_meals.where('inventories.quantity >= ?', ingredient_quantity).update_all(available: true)
      end
    end
  end

  def reset_branch_meal_availability
    branches_meals.each(&:update_available)
  end
end
