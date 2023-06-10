module RequireAdmin
  extend ActiveSupport::Concern

  included do
    before_action :require_admin
  end

  private def require_admin
    redirect_to root_path, alert: t('errors.require_admin.access_denied') unless @current_user.admin?
  end
end
