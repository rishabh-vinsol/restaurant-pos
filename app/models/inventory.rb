class Inventory < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :branch
  belongs_to :ingredient

  ### VALIDATIONS ###

  validates :quantity, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :ingredient_id, uniqueness: { scope: :branch_id }

  def add_quantity(quantity)
    self.quantity += quantity
  end
end
