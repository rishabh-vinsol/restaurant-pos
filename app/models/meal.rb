class Meal < ApplicationRecord
  ### ASSOCIATIONS ###

  has_one_attached :image
  has_many :ingredients_meals, class_name: 'IngredientMeal', dependent: :destroy
  has_many :ingredients, through: :ingredients_meals
  accepts_nested_attributes_for :ingredients_meals, update_only: true, allow_destroy: true
  has_many :branches_meals, class_name: 'BranchMeal', dependent: :destroy
  has_many :branches, through: :branches_meals
  has_many :line_items, dependent: :restrict_with_error

  ### VALIDATIONS ###

  validates :name, :ingredients_meals, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/png] }
  validates :image, size: { less_than: 5.megabytes }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  ### SCOPES ###

  scope :is_active, -> { where(active: true) }

  def set_non_veg
    update_column(:non_veg, ingredients.exists?(non_veg: true))
  end

  def set_price
    update_column(:price, ingredients_meals.sum(&:price))
    line_items.joins(:order).where(orders: { status: 'cart' }).each(&:update_total)
  end

  def type
    non_veg? ? 'Non-Veg' : 'Veg'
  end
end
