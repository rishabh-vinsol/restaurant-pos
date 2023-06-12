class OrdersController < ApplicationController
  before_action :set_line_item, only: %i[destroy_line_item update_line_item_quantity]
  before_action :set_line_items, only: :cart
  before_action :set_order, only: %i[order_success order_cancel]
  before_action :set_payment, only: %i[order_success order_cancel]
  skip_before_action :set_cart, only: :order_success

  def add_to_cart
    @line_item = @cart.add_meal(params[:meal_id])

    if @line_item.save
      render json: { cart_count: @cart.total_items }
    else
      render json: { status: 422, errors: @line_item.errors.full_messages.join(', ') }, status: 422
    end
  end

  def update_line_item_quantity
    @line_item.update(line_item_params) ? flash[:notice] = 'Item was updated successfully' : flash[:alert] = @line_item.errors.full_messages.join(', ')

    redirect_to cart_path
  end

  def destroy_line_item
    @line_item.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')
    redirect_to cart_path
  end

  def empty_cart
    @cart.line_items.destroy_all
    redirect_to cart_path, notice: t('.success')
  end

  def checkout
    if @cart.check_branch_inventory?
      @cart.update(order_params)
      @cart.update_inventory(false)
      stripe_session = create_stripe_session
      @payment = @cart.payments.create(user: @current_user, stripe_session_id: stripe_session.id)

      if @payment
        redirect_to stripe_session.url, allow_other_host: true
      else
        redirect_back_or_to cart_url, alert: t('.unsuccessful')
      end
    else
      set_line_items
      render :cart
    end
  end

  def order_success
    if @order.placed_on.nil?
      @order.received unless @order.placed_on
      @order.send_confirmation_email
      @payment.update(status: payment_status, mode: payment_type)
    end
    set_cart
  end

  def order_cancel
    @order.update_inventory(true)
    @payment.update(status: payment_status)
  end

  private def stripe_session
    Stripe::Checkout::Session.retrieve(@payment.stripe_session_id)
  end

  private def payment_status
    stripe_session.payment_status
  end

  private def payment_type
    payment_intent_id = stripe_session.payment_intent
    payment_method_id = Stripe::PaymentIntent.retrieve(payment_intent_id).payment_method
    Stripe::PaymentMethod.retrieve(payment_method_id).type
  end

  private def set_line_items
    @line_items = @cart.line_items.includes(:meal).order(:id)
  end

  private def set_payment
    @payment = @order.payments.last
  end

  private def set_line_item
    @line_item = @cart.line_items.find_by(id: params[:line_item_id])
    redirect_to cart_path, alert: t('errors.line_item.not_found') unless @line_item
  end

  private def stripe_line_items
    @cart.line_items.inject([]) do |arr, line_item|
      arr << { quantity: line_item.quantity,
              price_data: {
        currency: "inr",
        unit_amount: (line_item.meal.price * 100),
        product_data: {
          name: line_item.meal.name,
          description: line_item.meal.non_veg? ? 'Non-Veg' : 'Veg',
        },
      } }
    end
  end

  private def create_stripe_session
    Stripe::Checkout::Session.create({
      success_url: order_success_url(order_id: @cart),
      cancel_url: order_cancel_url(order_id: @cart),
      mode: 'payment',
      line_items: stripe_line_items,
    })
  end

  private def set_order
    @order = Order.find_by(id: params[:order_id])
    redirect_to root_path, alert: t('errors.orders.not_found') unless @order
  end

  private def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  private def order_params
    params.require(:order).permit(:contact_number, :pickup_time)
  end
end
