# Controller for user email verification after signup
class ConfirmationsController < ApplicationController
  before_action :set_user

  def verify_email
    if @user.verified_at?
      flash[:notice] = t('.already_verified')
    elsif @user.auth_token_valid?(params[:token])
      @user.update_verified_at
      flash[:notice] = t('.verified')
    else
      flash[:alert] = t('.unsuccessful_verification')
    end
    redirect_to login_url
  end

  private def set_user
    return unless params[:id] && params[:token]

    @user = User.find_by(id: params[:id])
  end
end
