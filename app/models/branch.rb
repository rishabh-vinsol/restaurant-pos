class Branch < ApplicationRecord
  validates :name, :opening_time, :closing_time, presence: true
  validates :opening_time, comparison: { less_than: :closing_time }, if: :closing_time
  validate :only_one_default, if: :default

  private def only_one_default
    if Branch.exists?(default: true)
      errors.add(:default, :present)
    end
  end
end
