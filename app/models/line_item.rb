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

  def update_total
    if order.cart?
      set_total
      save
    end
  end

  def check_inventory?
    branch_meal_inventory
    errors.empty?
  end

  private def branch_meal_inventory
    meal_max_quantity = ingredients_meals.joins(:inventories)
                                         .where(inventories: { branch_id: order.branch_id })
                                         .minimum('inventories.quantity/ingredients_meals.ingredient_quantity')
    if meal_max_quantity.zero?
      errors.add(:base, "#{meal.name} is out of stock")
    elsif quantity > meal_max_quantity
      errors.add(:base, "Cannot add more than #{meal_max_quantity} #{meal.name} to cart")
    end
  end

  private def set_total
    self.total = quantity * meal.price
  end

  def update_inventory(branch_id, action)
    ingredients_meals.each { |im| im.update_inventory(branch_id, quantity, action) }
  end

  def details
    {
      name: meal.name,
      quantity: quantity
    }
  end

  private def update_order_price
    order.set_total
  end
end