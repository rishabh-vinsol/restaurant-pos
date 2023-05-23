class Ingredient < ApplicationRecord
  has_one_attached :image

  validates :name, :price_per_portion, presence: true
  validates :non_veg, inclusion: { in: [true, false] }
  validate :image_file_size
  validate :image_file_type

  def image_file_size
    if image.attached? && image.blob.byte_size > 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end

  def image_file_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:image, "should be a JPG/JPEG or PNG file")
    end
  end
end
