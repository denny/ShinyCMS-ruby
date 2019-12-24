# Helper methods for turning CMS features on/off selectively
module FeatureFlagsHelper
  def enforce_feature_flags( feature_name )
    return if feature_enabled? feature_name

    flash[ :alert ] = I18n.t(
      'feature_flags.off_alert',
      feature_name: I18n.t( "feature_flags.#{feature_name}" )
    )
    # redirect_back( fallback_location: root_path )
    redirect_to root_path
  end

  def feature_enabled?( feature_name )
    feature = FeatureFlag.find_by( name: feature_name.to_s )

    return false if feature.blank?
    return true  if feature.enabled?

    return false unless current_user&.can? :view_admin_area

    feature.enabled_for_admins?
  end
end
