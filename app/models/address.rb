class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :pincode, presence: true
end
