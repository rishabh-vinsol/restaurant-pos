# Controller to signup new users
class RegistrationsController < ApplicationController
  skip_before_action :authorize

  before_action :check_logged_in, except: :logout
  before_action :initialize_user, only: :create_user
  before_action :set_user_by_email, only: %i[login_user reset_password_email verify_email reset_password_edit resend_verification_email update_password]

  def signup
    @user = User.new
  end

  def create_user
    if @user.save
      redirect_to login_url, alert: t('.verify_email')
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def login_user
    if @user && !@user.verified_at?
      flash.now[:alert] = t('.not_verified')
      render :login
    elsif @user.try(:authenticate, params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = t('.invalid')
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path, notice: t('.logged_out')
  end

  def resend_verification_email
    if @user.verified_at?
      flash[:notice] = t('.already_verified')
    else
      @user.send_authentication_email
      flash[:notice] = t('.sent_verification_email')
    end
    redirect_to login_url
  end

  def verify_email
    if @user.verified_at?
      flash[:notice] = t('.already_verified')
    elsif @user.auth_token_valid?(params[:token])
      @user.verified
      flash[:notice] = t('.verified')
    else
      flash[:alert] = t('.unsuccessful_verification')
    end
    redirect_to login_url
  end

  def reset_password_email
    if @user
      @user.generate_reset_token
      @user.send_password_reset_email
      redirect_to login_path, notice: t('.reset_password_email')
    else
      flash.now[:alert] = t('.invalid_user', email: params[:email])
      render :reset_password
    end
  end

  def reset_password_edit
    if @user.reset_token_valid?(params[:token])
      render :reset_password_edit
    else
      redirect_to login_path, alert: t('.auth_unsuccessful')
    end
  end

  def update_password
    user_password_params = params.require(:user).permit(:password, :password_confirmation)
    if @user.update(user_password_params)
      redirect_to login_path, notice: t('.password_changed')
    else
      render :reset_password_edit, status: :unprocessable_entity
    end
  end

  private def initialize_user
    @user = User.new(user_params)
  end

  private def set_user_by_email
    @user = User.find_by(email: params[:email])
    redirect_to login_path, alert: t('errors.users.not_found') unless @user
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
