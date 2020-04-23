# frozen_string_literal: true

# Pundit policy for web stats (powered by Ahoy)
class Admin::AhoyVisitPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :view_web, :stats
  end
end
