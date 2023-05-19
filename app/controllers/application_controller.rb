class ApplicationController < ActionController::Base
  before_action :authorize

  private def check_logged_in
    return unless cookies[:auth_token]

    redirect_to root_path, notice: t('notice.application.logged_in')
  end

  private def authorize
    return if current_user

    redirect_to login_path, alert: t('notice.application.login_request')
  end

  private def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
end
