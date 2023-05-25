# Model class Branch
class Branch < ApplicationRecord
  ### ASSOCIATIONS ###

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address, update_only: true

  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, presence: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validates :address, presence: true
  validate :only_one_default, if: :default

  ### CALLBACKS ###

  before_update :validate_single_default_branch

  private def only_one_default
    if default_was != true && Branch.exists?(default: true)
      errors.add(:default, :present)
    end
  end

  private def validate_single_default_branch
    if default_changed? && default_branch_exists?
      errors.add(:default, :present)
      throw(:abort)
    end
  end

  private def default_branch_exists?
    Branch.exists?(default: true)
  end
end
