class IngredientsController < ApplicationController
  before_action :set_ingredient, only: %i[ show edit update destroy ]

  def index
    @ingredients = Ingredient.all
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to ingredients_url, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to ingredients_url, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')

    redirect_to ingredients_url
  end

  private def set_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
    redirect_to ingredients_url, alert: t('errors.ingredients.not_found') unless @ingredient
  end

  private def ingredient_params
    params.require(:ingredient).permit(:name, :price_per_portion, :non_veg, :extra_request, :image)
  end
end
