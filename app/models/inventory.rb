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

  def append_inventory_logs(user_id, comment)
    if ingredient_id_previously_changed?
      inventory_logs.destroy_all
    elsif quantity_previously_changed?
      change_in_quantity = quantity_previous_change[1] - quantity_previous_change[0]
      @inventory_log = inventory_logs.build(quantity_changed: change_in_quantity, user_id: user_id, comment: comment)
      if @inventory_log.save
        return true
      else 
        errors.merge!(@inventory_log.errors)
        return false
      end
    end
    true
  end
end

