# Controller to signup new users
class RegistrationsController < ApplicationController
  skip_before_action :authorize

  before_action :check_logged_in, except: :logout
  before_action :initialize_user, only: :create_user
  before_action :token_presence, only: :verify_email
  before_action :set_user, only: [:verify_email, :forgot_password_edit]
  before_action :set_user_by_email, only: [:login_user, :forgot_password_email]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

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
      redirect_to "/"
    else
      flash.now[:alert] = t('.invalid')
      render :login
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to login_path, notice: t('.logged_out')
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

  def forgot_password_email
    if @user
      @user.generate_reset_token
      @user.send_password_reset_email
      redirect_to login_path, notice: t('.reset_password_email')
    else
      flash.now[:alert] = t('.invalid_user', email: params[:email])
      render :forgot_password
    end
  end

  def forgot_password_edit
    if @user.reset_token_valid?(params[:token])
      render :forgot_password_edit
    else
      redirect_to login_path, alert: t('.auth_unsuccessful')
    end
  end

  def update_password
    @user = User.find(user_params[:id])
    if @user.update(user_params)
      redirect_to login_path, notice: t('.password_changed')
    else
      render :forgot_password_edit, status: :unprocessable_entity
    end
  end

  private def initialize_user
    @user = User.new(user_params)
  end

  private def set_user_by_email
    @user = User.find_by(email: params[:email])
  end

  private def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation)
  end

  private def invalid_user
    redirect_to forgot_password_path, alert: t('errors.passwords.invalid_user')
  end

  private def token_presence
    return unless params[:token]
  end

  private def set_user
    @user = User.find_by(id: params[:id])
    redirect_to login_path, alert: t('errors.users.not_found') unless @user
  end
end
