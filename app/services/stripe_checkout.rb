class StripeCheckout
  DEFAULT_CURRENCY = 'inr'.freeze

  def initialize(user, success_url, cancel_url, order, payment = nil)
    @user = user
    @success_url = success_url
    @cancel_url = cancel_url
    @order = order
    @payment = payment
  end

  def self.initialize_with_payment(payment)
    new(nil, nil, nil, nil, payment)
  end

  def call
    create_session(find_customer)
  end

  def payment_type
    payment_intent_id = stripe_session.payment_intent
    payment_method_id = Stripe::PaymentIntent.retrieve(payment_intent_id).payment_method
    Stripe::PaymentMethod.retrieve(payment_method_id).type
  end

  private def find_customer
    if @user.stripe_id
      retrieve_customer(@user.stripe_id)
    else
      create_customer
    end
  end

  private def retrieve_customer(stripe_id)
    Stripe::Customer.retrieve(stripe_id)
  end

  private def create_customer
    customer = Stripe::Customer.create(
      name: @user.first_name + ' ' + @user.last_name,
      email: @user.email
    )
    @user.update(stripe_id: customer.id)
    customer
  end

  private def create_session(customer_id)
    Stripe::Checkout::Session.create({
      success_url: @success_url,
      cancel_url: @cancel_url,
      mode: 'payment',
      line_items: @order.stripe_line_items,
      customer: customer_id,
      payment_intent_data: {
        setup_future_usage: 'on_session'
      }
    })
  end

  private def stripe_session
    Stripe::Checkout::Session.retrieve(@payment.stripe_session_id)
  end
end
