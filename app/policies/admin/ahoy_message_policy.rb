# frozen_string_literal: true

# Pundit policy for email stats (powered by Ahoy::Email)
class Admin::AhoyMessagePolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :view_email, :stats
  end
end
