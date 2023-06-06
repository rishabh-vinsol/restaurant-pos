class BranchMeal < ApplicationRecord
  self.table_name = "branches_meals"

  ### ASSOCIATIONS ###

  belongs_to :branch
  belongs_to :meal
  has_many :ingredients_meals, through: :meal
  has_many :inventories, through: :branch

  ### VALIDATIONS ###

  validates :meal_id, uniqueness: { scope: :branch_id }

  ### CALLBACKS ###

  after_save_commit :update_available

  def update_available
    available_value = true
    im = ingredients_meals.joins(:inventories).where(inventories: { branch_id: branch_id })
    available_value = false if im.size < ingredients_meals.size || im.where('inventories.quantity < ingredients_meals.ingredient_quantity').any?

    update_columns(available: available_value)
  end
end
