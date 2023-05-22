class Ingredient < ApplicationRecord
  has_one_attached :image

  validates :name, :price_per_portion, presence: true
  validates :non_veg, inclusion: { in: [true, false] }
end
