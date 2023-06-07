# Controller to handle model Branch CRUD
class BranchesController < ApplicationController
  before_action :set_branch, only: %i[ show edit update destroy meals add_meal create_meal ]
  before_action :set_branch_meal, only: %i[ toggle_meal_active toggle_meal_inactive destroy_meal ]

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

  def update
    if @branch.update(branch_params)
      redirect_to branches_url, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')

    redirect_to branches_url
  end

  def meals
    @branch_meals = @branch.branches_meals.includes(:meal, :branch).order(:id)
  end

  def add_meal
    @branch_meal = BranchMeal.new
  end

  def create_meal
    @branch_meal = @branch.branches_meals.build(branch_meal_params)

    if @branch_meal.save
      redirect_to meals_branch_path(params[:id]), notice: t('.success')
    else
      render :add_meal, status: :unprocessable_entity
    end
  end

  def toggle_meal_active
    @branch_meal.activate
    redirect_to meals_branch_path(params[:id])
  end

  def toggle_meal_inactive
    @branch_meal.deactivate
    redirect_to meals_branch_path(params[:id])
  end

  private def set_branch_meal
    @branch_meal = BranchMeal.find_by(id: params[:branch_meal_id])
    redirect_to meals_branch_path(params[:id]), alert: t('errors.branch.meal_not_found') unless @branch_meal
  end

  private def set_branch
    @branch = Branch.find_by(id: params[:id])
    redirect_to branches_url, alert: t('errors.branches.not_found') unless @branch
  end

  private def branch_meal_params
    params.require(:branch_meal).permit(:meal_id, :active)
  end

  private def branch_params
    params.require(:branch).permit(:name, :default, :opening_time, :closing_time, address_attributes: [:address_line_1, :address_line_2, :city, :state, :pincode])
  end
end
