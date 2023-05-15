# Controller to handle users login
class SessionsController < ApplicationController
  before_action :set_user, only: :create

  def create
    if @user && !@user.verified_at?
      flash.now[:alert] = t('.not_verified')
      render :new
    elsif @user.try(:authenticate, params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = t('.invalid')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: t('.logged_out')
  end

  private def set_user
    @user = User.find_by(email: params[:email])
  end
end
