# Pundit policy for web stats (powered by ahoy)
class Admin::AhoyPolicy < Admin::DefaultPolicy
  def index?
    if controller_name == 'web_stats'
      @this_user.can? :web, :stats
    elsif controller_name == 'email_stats'
      @this_user.can? :email, :stats
    end
  end
end
