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

  after_create_commit :update_available

  def update_available
    available_value = true
    # FIX: variable name
    im = ingredients_meals.joins(:inventories).where(inventories: { branch_id: branch_id })
    available_value = false if im.nil? || im.count < ingredients_meals.size || im.where('inventories.quantity < ingredients_meals.ingredient_quantity').exists?

    update(available: available_value)
    send_notification unless available_value
  end

  def activate
    update(active: true)
  end

  def deactivate
    update(active: false)
  end

  # FIX: This should be called through callback for both available and active
  private def send_notification
    data = {
      meal_id: meal_id,
      branch_id: branch_id,
      meal_name: meal.name
    }
    ActionCable.server.broadcast('out_of_stock', data)
  end
end
