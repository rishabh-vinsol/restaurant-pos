class ItemsController < ApplicationController
  skip_before_action :authorize

  def menu
    @default_branch_id = current_user&.branch_id || params[:branch_id] || Branch.find_by_default(true).id || Branch.first.id
    @branch = Branch.find_by_id(@default_branch_id)

    @meals = Meal.includes(:branches_meals).where(active: true, branches_meals: { branch_id: @default_branch_id, available: true, active: true })
    @meals = @meals.where(non_veg: params[:non_veg]) if params[:non_veg] && params[:non_veg] != 'nil'
  end

  def set_branch
    current_user&.update(branch_id: params[:branch_id])
    redirect_to root_path(branch_id: params[:branch_id])
  end
end
