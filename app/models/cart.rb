# FIX: remove this if not using. Also remove table
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy
end
