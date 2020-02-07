# Admin controller for site settings
class Admin::SiteSettingsController < AdminController
  def index
    @settings = Setting.order( :name )
    authorise @settings.first
  end

  def update
    authorise Setting.all.first

    all_updated = update_settings( settings_params )
    if all_updated
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to site_settings_path
  end

  private

  def update_settings( params )
    flag = true
    params&.each_key do |key|
      next unless /value_(?<id>\d+)/ =~ key

      flag = false unless update_setting( id, params )
    end
    flag
  end

  def update_setting( id, params )
    setting = Setting.find( id )
    authorise setting
    level = params[ "level_#{id}" ]

    unless level.blank? || setting.level == level
      return false unless setting.update( level: level )
    end

    val = setting.values.find_by( user_id: nil )
    value = params[ "value_#{id}" ] || ''
    return true if val.value == value

    val.update!( value: value )
  end

  def settings_params
    params.permit(
      :authenticity_token, :commit, :_method, settings: {}
    )[ :settings ]
  end
end
