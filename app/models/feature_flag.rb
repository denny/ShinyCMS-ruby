# Model for feature flags
class FeatureFlag < ApplicationRecord
  def on?
    state == 'On'
  end

  def off?
    state == 'Off'
  end

  def admin_only?
    state == 'Admin Only'
  end
end
