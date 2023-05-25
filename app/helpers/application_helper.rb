# Application Helper
module ApplicationHelper
  def nav_link_class(path)
    "nav-link #{'active' if request.path.include?(path)}"
  end
end
