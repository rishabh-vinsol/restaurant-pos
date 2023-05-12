class SessionsController < ApplicationController
  # skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && !user.verified?
      flash.now[:alert] = t('.not_verified')
      render :new
    elsif user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to "/"
    else
      flash.now[:alert] = t('.invalid')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: t('.logged_out')
  end
end
