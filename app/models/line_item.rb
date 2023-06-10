class LineItem < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :order
  belongs_to :meal
  has_many :ingredients_meals, through: :meal

  ### CALLBACKS ###

  after_commit :update_order_price

  def price
    quantity * meal.price
  end

  def update_inventory(branch_id, inc)
    ingredients_meals.each { |im| im.update_inventory(branch_id, quantity, inc) }
  end

  private def update_order_price
    order.set_total
  end
end