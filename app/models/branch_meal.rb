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

  ### SCOPES ###

  scope :is_available, -> { where(available: true) }
  scope :is_active, -> { where(active: true) }

  def update_available
    available_value = true
    ing_meals = ingredients_meals.joins(:inventories).where(inventories: { branch_id: branch_id })
    available_value = false if ing_meals.nil? || ing_meals.count < ingredients_meals.size || ing_meals.where('inventories.quantity < ingredients_meals.ingredient_quantity').exists?

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
