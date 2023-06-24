# Model class Branch
class Branch < ApplicationRecord
  ### ASSOCIATIONS ###

  include Addressable
  has_many :inventories, dependent: :destroy
  has_many :branches_meals, class_name: 'BranchMeal', autosave: true, dependent: :destroy
  has_many :meals, through: :branches_meals
  has_many :orders, dependent: :restrict_with_error
  has_many :available_and_active_branches_meals, -> { is_active.is_available }, class_name: 'BranchMeal'
  has_many :active_meals, -> { is_active }, through: :available_and_active_branches_meals, source: :meal

  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, :url_slug, presence: true
  validates :name, :url_slug, uniqueness: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validates :address, presence: true
  validate :only_one_default, if: :default?
  validate :one_default_present, unless: :default?

  ### CALLBACKS ###

  before_validation :add_url_slug

  def to_param
    url_slug
  end

  def address_destroyable?
    false
  end

  private def add_url_slug
    self.url_slug = name.parameterize
  end

  private def other_default_present?
    Branch.where.not(id: id).exists?(default: true)
  end

  private def one_default_present
    errors.add(:default, :atleast_one_present) unless other_default_present?
  end

  private def only_one_default
    errors.add(:default, :present) if other_default_present?
  end
end
