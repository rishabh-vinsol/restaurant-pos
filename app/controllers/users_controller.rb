class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
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

  private def set_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path, alert: t('errors.users.not_found') unless @user
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :email, :password)
  end
end
