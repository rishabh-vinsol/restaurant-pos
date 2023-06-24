# Model class ingredient
class Ingredient < ApplicationRecord

  ### ASSOCIATIONS ###

  has_one_attached :image
  has_many :inventories, dependent: :destroy
  has_many :ingredients_meals, class_name: 'IngredientMeal', dependent: :restrict_with_error
  has_many :meals, through: :ingredients_meals

  ### VALIDATIONS ###

  validates :name, :price_per_portion, presence: true
  validates :non_veg, inclusion: { in: [true, false] }
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/png] }
  validates :image, size: { less_than: 5.megabytes }

  ### CALLBACKS ###
  after_commit :set_meal_price, if: proc { |ing| !ing.persisted? || ing.price_per_portion_previously_changed? }
  after_commit :set_meal_non_veg, if: proc { |ing| !ing.persisted? || ing.non_veg_previously_changed? }

  private def set_meal_price
    meals.each(&:set_price)
  end

  private def set_meal_non_veg
    meals.each(&:set_non_veg)
  end
end
