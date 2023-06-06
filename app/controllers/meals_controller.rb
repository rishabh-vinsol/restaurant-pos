class MealsController < ApplicationController
  before_action :set_meal, only: %i[ edit update destroy toggle_active toggle_inactive ]
  before_action :set_http_referer, only: :edit

  def index
    @meals = Meal.order(:id)
  end

  def new
    @meal = Meal.new
    @meal.ingredients_meals.build
  end

  def create
    @meal = Meal.new(meals_params)
    if @meal.save
      redirect_to meals_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @meal.update(meals_params)
      redirect_to session[:previous_referer], notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')

    redirect_to meals_path
  end

  def toggle_active
    @meal.update(active: true)
    redirect_to meals_path
  end

  def toggle_inactive
    @meal.update(active: false)
    redirect_to meals_path
  end

  private def set_meal
    @meal = Meal.find_by(id: params[:id])
    redirect_to meals_path, alert: t('errors.meals.not_found') unless @meal
  end

  private def meals_params
    params.require(:meal).permit(:name, :price, :active, :non_veg, :description, :image, ingredients_meals_attributes: [:ingredient_id, :ingredient_quantity, :_destroy, :id])
  end

  private def set_http_referer
    session[:previous_referer] = request.referer
  end
end
