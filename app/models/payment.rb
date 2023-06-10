class Payment < ApplicationRecord
  ### CONSTANTS

  STATUSES = {
    paid: 0,
    unpaid: 1
  }

  MODES = {
    card: 0,
    upi: 1
  }

  ### ENUMS ###

  enum status: STATUSES
  enum mode: MODES

  ### ASSICIATIONS ###

  belongs_to :order
  belongs_to :user
end
