# Pundit policy for web stats (powered by ahoy)
class Admin::AhoyPolicy < Admin::DefaultPolicy
  def index?
    if @record.class.name == 'Ahoy::Visit'
      @this_user.can? :view_web, :stats
    elsif @record.class.name == 'Ahoy::Message'
      @this_user.can? :view_email, :stats
    else
      @this_user.can? :view_email, :stats
    end
  end
end
