class ConfirmationsController < ApplicationController
  def verify_email
    return unless params[:id] && params[:token]

    @user = User.find_by(id: params[:id])

    if @user.verified?
      redirect_to login_url, notice: t(".already_verified")
    elsif @user.auth_token_valid?(params[:token])
      @user.update(verified_at: Time.now)
      redirect_to login_url, notice: t(".verified")
    else
      redirect_to login_url, alert: t(".unsuccessful_verification")
    end
  end
end
