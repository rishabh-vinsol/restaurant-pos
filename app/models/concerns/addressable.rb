module Addressable
  extend ActiveSupport::Concern
  included do
    has_one :address, as: :addressable, dependent: :destroy
    accepts_nested_attributes_for :address, update_only: true
  end
end
