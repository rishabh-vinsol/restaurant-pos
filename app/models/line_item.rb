class LineItem < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :order
  belongs_to :meal
  has_many :ingredients_meals, through: :meal

  ### VALIDATIONS ###

  validate :branch_meal_inventory
  validates :quantity, numericality: { greater_than: 0 }

  ### CALLBACKS ###

  before_save :set_total, if: proc { |li| li.order.cart? }
  after_commit :update_order_price

  def branch_meal_inventory
    meal_max_quantity = ingredients_meals.joins(:inventories)
    .where(inventories: { branch_id: order.branch_id })
    .minimum('inventories.quantity/ingredients_meals.ingredient_quantity')
    errors.add(:base, "Cannot add more than #{meal_max_quantity} #{meal.name} to cart") if quantity > meal_max_quantity
  end

  def update_total
    if order.cart?
      set_total
      save
    end
  end

  private def set_total
    self.total = quantity * meal.price
  end

  private def update_order_price
    order.set_total
  end
end
