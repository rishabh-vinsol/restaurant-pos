# Model class ingredient
class Ingredient < ApplicationRecord
  has_one_attached :image

  validates :name, :price_per_portion, presence: true
  validates :non_veg, inclusion: { in: [true, false] }
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/png] }
  validates :image, size: { less_than: 5.megabytes }
end
