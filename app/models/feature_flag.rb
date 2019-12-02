# Model for feature flags
class FeatureFlag < ApplicationRecord
  def on?
    state == I18n.t( 'admin.features.feature_on' )
  end

  def off?
    state == I18n.t( 'admin.features.feature_off' )
  end

  def admin_only?
    state == I18n.t( 'admin.features.admin_only' )
  end
end
