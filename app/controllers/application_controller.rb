class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_cart, if: :current_user

  helper_method :current_user

  def set_cart
    branch_id = @current_user.branch_id || params[:branch_id] || Branch.find_by_default(true).id || Branch.first.id
    @cart = Order.find_or_initialize_by(user_id: @current_user.id, status: 'cart', branch_id: branch_id)
  end

  private def check_logged_in
    return unless cookies[:auth_token]

    redirect_to root_path, notice: t('notice.application.logged_in')
  end

  private def authorize
    return if current_user

    if request.xhr?
      render json: { status: 401, login_url: login_url }, status: :unauthorized
    else
      redirect_to login_path, alert: t('notice.application.login_request')
    end
  end

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
end
