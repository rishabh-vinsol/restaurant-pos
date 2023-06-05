# Model class Branch
class Branch < ApplicationRecord
  ### ASSOCIATIONS ###

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, update_only: true

  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, presence: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validates :address, presence: true
  validate :only_one_default, if: :default

  def self.default_branch_exists?
    exists?(default: true)
  end

  def address_destroyable?
    false
  end

  private def only_one_default
    errors.add(:default, :present) if default_was != true && Branch.default_branch_exists?
  end
end
