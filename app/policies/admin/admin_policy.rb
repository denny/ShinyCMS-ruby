# Pundit policy for admin index controller
class Admin::AdminPolicy < DefaultPolicy
  def index?
    @this_user.can? :view_admin_area
  end
end
