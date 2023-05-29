# Controller to handle Inventories CRUD
class InventoriesController < ApplicationController
  before_action :set_branch_id
  before_action :set_branch, only: %i[new edit index update]
  before_action :get_or_set_inventory, only: :create
  before_action :set_inventory, only: %i[edit update destroy]

  def index
    @inventories = Inventory.includes(:ingredient).where(branch_id: @branch_id).order(:ingredient_id)
  end

  def new
    @inventory = Inventory.new
  end

  def create
    if @inventory.save
      redirect_to branch_inventories_path(@branch_id), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to branch_inventories_path(@branch_id), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')
    redirect_to branch_inventories_path(@branch_id)
  end

  private def set_branch_id
    @branch_id = params[:branch_id]
  end

  private def set_branch
    @branch = Branch.find_by(id: @branch_id)
  end

  private def get_or_set_inventory
    if @inventory = Inventory.find_by(find_inventory_params)
      @inventory.add_quantity(inventory_params[:quantity].to_i)
    else
      @inventory = Inventory.new(inventory_params)
    end
  end

  private def set_inventory
    @inventory = Inventory.find_by(id: params[:id])
    redirect_to branch_inventories_path(@branch_id), alert: t('errors.inventories.not_found') unless @inventory
  end

  private def find_inventory_params
    params.require(:inventory).permit(:branch_id, :ingredient_id)
  end

  private def inventory_params
    params.require(:inventory).permit(:branch_id, :ingredient_id, :quantity)
  end
end
