# Model class Branch
class Branch < ApplicationRecord
  ### ASSOCIATIONS ###

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, update_only: true
  has_many :inventories, dependent: :destroy
  has_many :branches_meals, class_name: 'BranchMeal', autosave: true, dependent: :destroy
  has_many :meals, through: :branches_meals
  has_many :orders, dependent: :restrict_with_error
  has_many :available_and_active_branches_meals, -> { where(available: true, active: true) }, class_name: 'BranchMeal'
  has_many :active_meals, -> { where(active: true) }, through: :available_and_active_branches_meals, source: :meal

  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, presence: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validates :address, presence: true
  validate :only_one_default, if: :default

  def self.default_branch_exists?
    exists?(default: true)
  end

  def address_destroyable?
    false
  end

  private def only_one_default
    errors.add(:default, :present) if default_was != true && Branch.default_branch_exists?
  end
end
