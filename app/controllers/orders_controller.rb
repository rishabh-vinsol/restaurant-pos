class OrdersController < ApplicationController
  skip_before_action :set_cart, only: :stripe_checkout_success
  before_action :set_line_item, only: %i[destroy_line_item update_line_item_quantity]
  before_action :set_line_items, only: :cart
  before_action :set_order, only: %i[stripe_checkout_success stripe_checkout_cancel]
  before_action :set_payment, only: %i[stripe_checkout_success stripe_checkout_cancel]

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
    unless @cart.check_branch_inventory?
      set_line_items
      render :cart
    end

    ActiveRecord::Base.transaction do
      @cart.update(order_params)
      stripe_session = StripeCheckout.new(@current_user,
                                          stripe_checkout_success_url(order_id: @cart),
                                          stripe_checkout_cancel_url(order_id: @cart),
                                          @cart).call
      @payment = @cart.payments.new(stripe_session_id: stripe_session.id, status: 'pending')

      if @payment.save
        redirect_to stripe_session.url, allow_other_host: true
      else
        redirect_back_or_to cart_url, alert: t('.unsuccessful')
      end
    end
  end

  def stripe_checkout_success
    if @order.placed_on.nil?
      @payment.update(status: 'successful', mode: StripeCheckout.initialize_with_payment(@payment).payment_type)
    end
    set_cart
  end

  def stripe_checkout_cancel
    @payment.update(status: 'unsuccessful')
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
