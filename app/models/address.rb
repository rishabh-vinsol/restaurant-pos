class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :pincode, :city, :state, :address_line_1, presence: true
  validates :address_line_1, :address_line_2, length: { maximum: 50 }
  validates :city, :state, length: { maximum: 20 }
end
