# Model class Branch
# FIX: Create a view to list where we will select an ingredient and it will show all ingredients left in the branches grouped by branch.
# eg: Cheese Slice
# Patel Nagar -> Ingredient Left: 5, Ingredient in transit: 2, Increase Inventory button.
# Rajendra Place -> Ingredient Left: 5, Ingredient in transit: 2
# Rajendra Place -> Ingredient Left: 5, Ingredient in transit: 2


# Additional Reports Sections

class Branch < ApplicationRecord
  ### ASSOCIATIONS ###

  # FIX: Add it in concern
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, update_only: true

  has_many :inventories, dependent: :destroy
  has_many :branches_meals, class_name: 'BranchMeal', autosave: true, dependent: :destroy
  has_many :meals, through: :branches_meals
  has_many :orders, dependent: :restrict_with_error
  # FIX: move where(available: true, active: true) in branch_meal model
  has_many :available_and_active_branches_meals, -> { where(available: true, active: true) }, class_name: 'BranchMeal'
  has_many :active_meals, -> { where(active: true) }, through: :available_and_active_branches_meals, source: :meal

  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, :url_slug, presence: true
  validates :name, :url_slug, uniqueness: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validates :address, presence: true
  # FIX: use rails method :default?
  validate :only_one_default, if: :default

  ### CALLBACKS ###

  before_validation :add_url_slug

  def to_param
    url_slug
  end

  def self.default_branch_exists?
    exists?(default: true)
  end

  def address_destroyable?
    false
  end

  private def add_url_slug
    self.url_slug = name.parameterize
  end

  # FIX: Branch.where.not(id: id).exists?(default: true)
  # FIX: Also Add validation to have atleast one default.
  private def only_one_default
    errors.add(:default, :present) if default_was != true && Branch.default_branch_exists?
  end
end
