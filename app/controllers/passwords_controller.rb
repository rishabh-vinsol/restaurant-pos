class PasswordsController < ApplicationController
  layout "user"
  skip_before_action :authorize
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

  def create
    user = User.find_by_email params[:email]

    if user
      user.generate_reset_token
      user.send_password_reset_email
      redirect_to login_path, notice: t(".reset_password_email")
    else
      flash.now[:alert] = t('.invalid_user', email: params[:email])
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user.reset_token_valid?(params[:token])
      render :edit
    else
      redirect_to login_path, alert: t('.auth_unsuccessful')
    end
  end

  def update
    @user = User.find(user_params[:id])
    if @user.update(user_params)
      redirect_to login_path, notice: t('.password_changed')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private def user_params
    params.require(:user).permit(:id, :password, :password_confirmation)
  end

  def invalid_user
    redirect_to forgot_password_path, alert: t('errors.passwords.invalid_user')
  end
end
