# Controller to handle model Branch CRUD
class Admin::BranchesController < ApplicationController
  include RequireAdmin
  before_action :set_branch, only: %i[show edit update destroy meals add_meal create_meal]
  before_action :set_branch_meal, only: %i[toggle_meal_active toggle_meal_inactive]
  before_action :set_order, only: %i[order_ready order_picked_up order_cancelled]

  def index
    @branches = Branch.order(:id)
  end

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to branches_url, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @orders = @branch.orders.includes(:meals, :user).where.not(status: 'cart').order(pickup_time: :desc)
  end 

  def update
    if @branch.update(branch_params)
      redirect_to branches_url, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')
    redirect_to branches_path
  end

  def meals
    @branch_meals = @branch.branches_meals.includes(:meal, :branch).order(:placed_on)
  end

  def add_meal
    @branch_meal = BranchMeal.new
  end

  def create_meal
    @branch_meal = @branch.branches_meals.build(branch_meal_params)

    if @branch_meal.save
      redirect_to meals_branch_path(params[:url_slug]), notice: t('.success')
    else
      render :add_meal, status: :unprocessable_entity
    end
  end

  def toggle_meal_active
    @branch_meal.activate
    redirect_to meals_branch_path(params[:url_slug])
  end

  def toggle_meal_inactive
    @branch_meal.deactivate
    redirect_to meals_branch_path(params[:url_slug])
  end

  def order_ready
    @order.ready
    redirect_to branch_path(params[:url_slug])
  end

  def order_picked_up
    @order.picked_up
    redirect_to branch_path(params[:url_slug])
  end

  def order_cancelled
    @order.cancelled
    @order.update_inventory(true)
    redirect_to branch_path(params[:url_slug])
  end

  private def set_order
    @order = Order.find_by(id: params[:order_id])
    redirect_to branch_path(params[:url_slug]), alert: 'Order not found' unless @order
  end

  private def set_branch_meal
    @branch_meal = BranchMeal.find_by(id: params[:branch_meal_id])
    redirect_to meals_branch_path(params[:url_slug]), alert: t('errors.branch.meal_not_found') unless @branch_meal
  end

  private def set_branch
    @branch = Branch.find_by(url_slug: params[:url_slug])
    redirect_to branches_url, alert: t('errors.branches.not_found') unless @branch
  end

  private def set_line_item
    @line_item = LineItem.find_by(id: params[:line_item_id])
    redirect_to branch_path(params[:url_slug]), alert: 'Meal not found' unless @line_item
  end

  private def branch_meal_params
    params.require(:branch_meal).permit(:meal_id, :active)
  end

  private def branch_params
    params.require(:branch).permit(:name, :default, :opening_time, :closing_time, address_attributes: [:address_line_1, :address_line_2, :city, :state, :pincode])
  end
end
