# Model class Payment
class Payment < ApplicationRecord
  ### CONSTANTS

  STATUSES = {
    pending: 0,
    successful: 1,
    unsuccessful: 2
  }

  MODES = {
    card: 0
  }

  ### ENUMS ###

  enum status: STATUSES
  enum mode: MODES

  ### ASSICIATIONS ###

  belongs_to :order

  ### CALLBACKS ###

  after_create_commit :decrease_inventory
  after_update_commit :order_status_received, if: %i[successful? status_previously_changed?]
  after_update_commit :increase_inventory, if: %i[unsuccessful? status_previously_changed?]

  private def decrease_inventory
    order.update_inventory('decrease')
  end

  private def increase_inventory
    order.update_inventory('increase')
  end

  private def order_status_received
    order.receive
  end
end
