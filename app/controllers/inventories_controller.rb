# Controller to handle Inventories CRUD
class InventoriesController < ApplicationController
  before_action :set_branch
  before_action :set_inventory, only: %i[edit update destroy logs]
  before_action :set_inventory_log, only: :destroy_log

  def index
    @inventories = @branch.inventories.includes(:ingredient).order(:ingredient_id)
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.find_or_initialize_by(find_inventory_params)
    @inventory.add_quantity(params[:inventory][:quantity].to_i)
    if @inventory.save
      redirect_to branch_inventories_path(@branch), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to branch_inventories_path(@branch), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')
    redirect_to branch_inventories_path(@branch)
  end

  def logs
    @inventory_logs = InventoryLog.includes(:user).where(inventory_id: @inventory.id)
    @product_name = @inventory.ingredient.name
  end

  private def set_branch
    @branch = Branch.find_by(id: params[:branch_id])
    redirect_to branches_url, alert: t('errors.branches.not_found') unless @branch
  end

  private def set_inventory_log
    @inventory_log = InventoryLog.find_by(id: params[:inventory_log_id])
  end

  private def set_inventory
    @inventory = Inventory.find_by(id: params[:id])
    redirect_to branch_inventories_path(@branch), alert: t('errors.inventories.not_found') unless @inventory
  end

  private def find_inventory_params
    params.require(:inventory).permit(:branch_id, :ingredient_id)
  end

  private def inventory_params
    ip = params.require(:inventory).permit(:branch_id, :ingredient_id, :quantity, inventory_logs_attributes: [:comment, :user_id])
    ip[:inventory_logs_attributes]['0'].merge!(quantity_changed: quantity_changed)
    ip
  end

  private def quantity_changed
    params[:inventory][:quantity].to_i - @inventory.quantity
  end
end
