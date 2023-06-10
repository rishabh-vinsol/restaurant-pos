class Order < ApplicationRecord
  ### CONSTANTS ###

  STATUSES = {
    cart: 0,
    received: 1,
    cancelled: 2,
    ready: 3,
    'picked up': 4
  }

  enum status: STATUSES

  ### ASSOCIATIONS ###

  belongs_to :user
  belongs_to :branch
  has_many :line_items, autosave: true, dependent: :delete_all
  has_many :meals, through: :line_items
  has_many :ingredients_meals, through: :meals

  def add_meal(meal_id)
    li = line_items.find_or_initialize_by(meal_id: meal_id)
    li.quantity += 1
    li
  end

  def total_items
    line_items.sum(:quantity)
  end

  def set_total
    update(total: line_items.to_a.sum(&:price))
  end
end
