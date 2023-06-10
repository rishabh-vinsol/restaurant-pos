class Order < ApplicationRecord
  ### CONSTANTS ###

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
  has_many :payments, dependent: :destroy
  has_many :ingredients_meals, through: :meals

  ### CALLBACKS ###

  before_save :check_placed_on, if: :cancelled?

  def add_meal(meal_id)
    li = line_items.find_or_initialize_by(meal_id: meal_id)
    li.quantity += 1
    li
  end

  def total_items
    line_items.sum(:quantity)
  end

  def set_total
    update(total: line_items.to_a.sum(&:price))
  end

  def received
    update(status: :received, placed_on: Time.now)
  end

  def ready
    update(status: :ready)
  end

  def picked_up
    update(status: 'picked up', picked_up_at: Time.now)
  end

  def cancelled
    update(status: :cancelled)
  end

  def cancellable?
    (Time.now < pickup_time) && !picked_up? && !cancelled?
  end

  def check_branch_inventory?
    meal_max_quantity = meals.joins(ingredients_meals: :inventories)
          .where(inventories: { branch_id: branch_id })
          .group(:id).minimum('inventories.quantity/ingredients_meals.ingredient_quantity')
    line_items.joins(:meal).each do |line_item|
      if (line_item.quantity > meal_max_quantity[line_item.meal_id]) && meal_max_quantity[line_item.meal_id] == 0
        errors.add(:base, "#{line_item.meal.name} is out of stock")
      elsif line_item.quantity > meal_max_quantity[line_item.meal_id]
        errors.add(:base, "Only #{meal_max_quantity[line_item.meal.id]} quantity of #{line_item.meal.name} can be added")
      end
    end
    errors.empty?
  end

  def update_inventory(inc)
    line_items.each {|li| li.update_inventory(branch_id, inc) }
  end

  def send_confirmation_email
    OrderMailer.with(user_id: user_id, order_id: id).confirmation.deliver_later
  end

  def details
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

  private def check_placed_on
    throw(:abort) if pickup_time - Time.now < 30.minutes
  end
end
