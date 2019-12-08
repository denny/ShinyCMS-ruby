# Helper methods for turning CMS features on/off selectively
module FeaturesHelper
  def enforce_feature_flags( feature_name )
    return if feature_enabled? feature_name

    redirect_to root_path, alert:
      I18n.t( 'feature.off_alert', feature_name: feature_name )
  end

  def feature_enabled?( feature_name )
    feature = FeatureFlag.find_by( name: feature_name )

    return false if feature.blank?
    return true  if feature.enabled?

    return false unless current_user&.can? 'view_admin_area'

    feature.enabled_for_admins?
  end
end
