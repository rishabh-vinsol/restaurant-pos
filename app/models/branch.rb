# Model class Branch
class Branch < ApplicationRecord
  ### VALIDATIONS ###

  validates :name, :opening_time, :closing_time, presence: true
  validates :closing_time, comparison: { greater_than: :opening_time }, if: :closing_time
  validate :only_one_default, if: :default

  private def only_one_default
    if default_was != true && Branch.exists?(default: true)
      errors.add(:default, :present)
    end
  end
end
