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

  private def update_order_price
    order.set_total
  end
end
