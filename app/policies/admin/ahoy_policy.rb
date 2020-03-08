# Pundit policy for web stats (powered by ahoy)
class Admin::AhoyPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :list, :web_stats
  end

  def show?
    @this_user.can? :show, :web_stats
  end
end
