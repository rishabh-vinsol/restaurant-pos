class ApplicationController < ActionController::Base
  before_action :authorize

  private def redirect_to_homepage_if_logged_in
    return unless cookies[:auth_token]

    redirect_to store_index_path, notice: t('notice.application.logged_in')
  end

  private def authorize
    return if current_user

    redirect_to login_url, alert: t('notice.application.login_request')
  end

  private def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
end
