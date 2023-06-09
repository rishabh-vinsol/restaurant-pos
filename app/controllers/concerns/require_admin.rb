module RequireAdmin
  extend ActiveSupport::Concern

  included do
    before_action :require_admin
  end

  private def require_admin
    redirect_to root_path, alert: "You don't have privilage to access that section" unless @current_user.admin?
  end
end
