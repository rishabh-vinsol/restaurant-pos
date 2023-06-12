class OrdersController < ApplicationController
  before_action :set_line_item, only: %i[destroy_line_item update_line_item_quantity]
  before_action :set_line_items, only: :cart

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
  end

  private def set_line_items
    @line_items = @cart.line_items.includes(:meal).order(:id)
  end

  private def set_line_item
    @line_item = @cart.line_items.find_by(id: params[:line_item_id])
    redirect_to cart_path, alert: t('errors.line_item.not_found') unless @line_item
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  private def order_params
    params.require(:order).permit(:contact_number, :pickup_time)
  end
end
