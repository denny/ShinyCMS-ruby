# frozen_string_literal: true

# Pundit policy for feature flag administration
class Admin::FeatureFlagPolicy < Admin::DefaultPolicy
  def update?
    @this_user.can? :edit, :feature_flags
  end
end
