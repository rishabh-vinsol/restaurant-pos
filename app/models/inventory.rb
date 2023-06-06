class Inventory < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :branch
  belongs_to :ingredient
  has_many :branches_meals, through: :branch
  has_many :ingredients_meals, through: :ingredient

  ### VALIDATIONS ###

  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ingredient_id, uniqueness: { scope: :branch_id }

  ### CALLBACKS ###

  after_destroy_commit :reset_branch_meal_availability
  after_save_commit :set_branch_meal_availability

  def add_quantity(quantity)
    self.quantity += quantity
  end

  private def set_branch_meal_availability
    target_branches_meals = branches_meals.joins(:ingredients_meals).where('ingredients_meals.ingredient_id = ?', ingredient_id)

    target_branches_meals.where('ingredients_meals.ingredient_quantity > ?', quantity).update_all(available: false)
    target_branches_meals.where('ingredients_meals.ingredient_quantity <= ?', quantity).update_all(available: true)
  end

  def reset_branch_meal_availability
    branches_meals.joins(:ingredients_meals).where(ingredients_meals: {ingredient_id: ingredient_id}).each(&:update_available)
  end
end
