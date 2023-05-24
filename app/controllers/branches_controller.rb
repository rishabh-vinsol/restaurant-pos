# Controller to handle model Branch CRUD
class BranchesController < ApplicationController
  before_action :set_branch, only: %i[ show edit update destroy ]

  def index
    @branches = Branch.all
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
      redirect_to branches_url, notice: t('success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy ? flash[:notice] = t('success') : flash[:alert] = t('failure')

    redirect_to branches_url
  end

  private def set_branch
    @branch = Branch.find_by(id: params[:id])
    redirect_to branches_url, alert: t('errors.branches.not_found') unless @branch
  end

  private def branch_params
    params.require(:branch).permit(:name, :default, :opening_time, :closing_time)
  end
end
