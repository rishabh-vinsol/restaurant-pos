class ApplicationController < ActionController::Base
  before_action :authorize

  private def check_logged_in
    return unless session[:user_id]

    redirect_to root_path, notice: t('notice.application.logged_in')
  end

  private def authorize
    return if current_user

    redirect_to login_path, alert: t('notice.application.login_request')
  end

  private def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
