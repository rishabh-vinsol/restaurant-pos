# Model class Order
class Order < ApplicationRecord
  ### CONSTANTS ###

  DEFAULT_CURRENCY = 'inr'.freeze
  STATUSES = {
    cart: 0,
    received: 1,
    cancelled: 2,
    ready: 3,
    'picked up': 4
  }

  enum status: STATUSES

  ### ASSOCIATIONS ###

  belongs_to :user
  belongs_to :branch
  has_many :line_items, autosave: true, dependent: :delete_all
  has_many :meals, through: :line_items
  has_many :payments, dependent: :restrict_with_error
  has_many :ingredients_meals, through: :meals

  ### CALLBACKS ###

  before_save :check_placed_on, if: %i[cancelled? status_changed?]
  after_commit :send_confirmation_email, if: %i[received? status_previously_changed?]
  after_update_commit :broadcast_order, if: %i[received? status_previously_changed?]

  def add_meal(meal_id)
    li = line_items.find_or_initialize_by(meal_id: meal_id)
    li.quantity += 1
    li
  end

  def total_items
    line_items.sum(:quantity)
  end

  def set_total
    update(total: line_items.to_a.sum(&:total))
  end

  def receive
    update(status: :received, placed_on: Time.now)
  end

  def mark_ready
    update(status: :ready)
  end

  def mark_picked_up
    update(status: 'picked up', picked_up_at: Time.now)
  end

  def cancel
    update(status: :cancelled)
    update_inventory('increase')
  end

  def cancellable?
    (pickup_time - Time.now > 30.minutes) && !picked_up? && !cancelled?
  end

  def check_branch_inventory?
    line_items.joins(:meal).each do |line_item|
      errors.merge!(line_item.errors) unless line_item.check_inventory?
    end
    errors.empty?
  end

  def update_inventory(action)
    line_items.each {|li| li.update_inventory(branch_id, action) }
  end

  def stripe_line_items
    line_items.inject([]) do |arr, line_item|
      arr << { quantity: line_item.quantity,
               price_data: { currency: DEFAULT_CURRENCY,
                             unit_amount: (line_item.meal.price * 100),
                             product_data: { name: line_item.meal.name,
                                             description: line_item.meal.type } } }
    end
  end

  private def send_confirmation_email
    OrderMailer.with(user_id: user_id, order_id: id).confirmation.deliver_later
  end

  private def details
    {
      id: id,
      customer_name: user.first_name,
      line_items: line_items.map(&:details),
      total: total,
      date: placed_on.strftime('%D'),
      pickup_time: pickup_time.strftime('%I:%M %p'),
      picked_up_at: picked_up_at&.strftime('%I:%M %p'),
      status: status,
      branch_url_slug: branch.url_slug
    }
  end

  private def broadcast_order
    ActionCable.server.broadcast('order_success', details)
  end

  private def check_placed_on
    return unless pickup_time - Time.now < 30.minutes

    errors.add(:base, 'Pickup time is within 30 minutes')
    throw(:abort)
  end
end
