# Controller to handle users login
class SessionsController < ApplicationController
  layout 'user'
  skip_before_action :authorize
  before_action :redirect_to_homepage_if_logged_in, except: :destroy
  before_action :set_user, only: :create

  def create
    if @user && !@user.verified_at?
      flash.now[:alert] = t('.not_verified')
      render :new
    elsif @user.try(:authenticate, params[:password])
      set_cookies
      redirect_to root_path, notice: 'Logged In'
    else
      flash.now[:alert] = t('.invalid')
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to login_path, notice: t('.logged_out')
  end

  private def set_user
    @user = User.find_by(email: params[:email])
  end

  private def set_cookies
    cookies[:auth_token] = params[:remember_me] == '1' ? { value: @user.auth_token, expires: 10.days.from_now } : @user.auth_token
  end
end
