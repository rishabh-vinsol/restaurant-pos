class Meal < ApplicationRecord
  ### ASSOCIATIONS ###

  has_one_attached :image
  has_many :ingredients_meals, class_name: 'IngredientMeal', dependent: :destroy
  has_many :ingredients, through: :ingredients_meals
  accepts_nested_attributes_for :ingredients_meals, update_only: true, allow_destroy: true

  ### VALIDATIONS ###

  validates :name, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/png] }
  validates :image, size: { less_than: 5.megabytes }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def set_non_veg
    update_column(:non_veg, ingredients.exists?(non_veg: true))
  end

  def set_price
    update_column(:price, ingredients_meals.sum(&:price))
  end
end
