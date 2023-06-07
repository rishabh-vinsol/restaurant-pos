class Inventory < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :branch
  belongs_to :ingredient
  has_many :inventory_logs, dependent: :destroy
  accepts_nested_attributes_for :inventory_logs

  ### VALIDATIONS ###

  validates :quantity, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :ingredient_id, uniqueness: { scope: :branch_id }

  def add_quantity(quantity)
    self.quantity += quantity
  end
end
