class Admin::UsersController < ApplicationController
  include RequireAdmin
  before_action :set_user, only: %i[show edit update destroy send_authentication_email send_password_reset_email update_branch]
  skip_before_action :require_admin, only: :update_branch

  def index
    @users = User.order(:id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_url, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_url, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy ?  flash[:notice] = t('.success') : flash[:alert] = t('.failure')
    redirect_to users_path
  end

  def send_authentication_email
    @user.send_authentication_email
    redirect_to edit_user_path(@user), notice: t('.email_sent')
  end

  def send_password_reset_email
    @user.send_password_reset_email
    redirect_to edit_user_path(@user), notice: t('.email_sent')
  end

  def update_branch
    @user.update(branch_id: params[:branch_id])
    redirect_to root_path(branch_id: params[:branch_id])
  end

  private def set_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path, alert: t('errors.users.not_found') unless @user
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :email, :password, :password_confirmation, address_attributes: [:address_line_1, :address_line_2, :city, :state, :pincode, :_destroy])
  end
end
