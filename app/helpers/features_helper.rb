# Helper methods for turning CMS features on/off selectively
module FeaturesHelper
  def enforce_feature_flags( feature_name )
    return if feature_enabled?( feature_name )

    redirect_to root_path, alert: feature_alert_message( feature_name )
  end

  def feature_enabled?( feature_name )
    feature = FeatureFlag.find_by( name: feature_name )

    return false if feature.blank?
    return false if feature.off?
    return true  if feature.on?

    return false unless current_user&.admin?

    feature.admin_only?
  end

  def feature_alert_message( feature_name )
    alert_start = I18n.t 'admin.features.alert_start'
    alert_end   = I18n.t 'admin.features.alert_end'

    "#{alert_start} '#{feature_name.titlecase}' #{alert_end}"
  end
end
