# Controller to show restaurant menu
class ItemsController < ApplicationController
  skip_before_action :authorize
  before_action :set_branch

  def menu
    @meals = @branch.active_meals.includes(image_attachment: :blob)
    @meals = @meals.where(non_veg: params[:non_veg]) if params[:non_veg] && params[:non_veg] != 'nil'
  end

  private def set_branch
    @default_branch_id = current_user&.branch_id || params[:branch_id] || Branch.find_by_default(true).id || Branch.first.id
    @branch = Branch.find_by_id(@default_branch_id)
  end
end
