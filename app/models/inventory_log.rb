class InventoryLog < ApplicationRecord
  ### ASSOCIATIONS ###

  belongs_to :user
  belongs_to :inventory

  ### VALIDATIONS ###

  validates :comment, presence: true
end
