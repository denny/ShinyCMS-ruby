# Admin controller for site settings
class Admin::SiteSettingsController < AdminController
  def index
    @settings = Setting.order( :name )
    authorise @settings.first
  end

  def update
    authorise Setting.all.first

    all_updated = update_settings( settings_params )
    if all_updated.nil?
      flash[ :alert_info ] = t( '.unchanged' )
    elsif all_updated
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to admin_site_settings_path
  end

  private

  def update_settings( params )
    flags = initialise_flags
    params&.each_key do |key|
      next unless /value_(?<id>\d+)/ =~ key

      flag  = update_setting( id, params )
      flags = update_flags( flag, flags )
    end
    return if flags[ :no_change ]

    flags[ :no_errors ]
  end

  def update_setting( id, params )
    setting = Setting.find( id )
    authorise setting

    level_flag = update_level( setting, params )
    value_flag = update_value( setting, params )

    return if level_flag.nil? && value_flag.nil?
    return false if level_flag == false || value_flag == false

    true
  end

  def update_level( setting, params )
    level_param = params[ "level_#{setting.id}" ]

    return if level_param.blank? || setting.level == level_param

    _ret = setting.update( level: level_param )
  end

  def update_value( setting, params )
    value_param = params[ "value_#{setting.id}" ] || ''

    value = setting.values.find_by( user_id: nil )

    _ret = value.update( value: value_param ) unless value.value == value_param
  end

  def initialise_flags
    flags = {}
    flags[ :no_change ] = true
    flags[ :no_errors ] = true
    flags
  end

  def update_flags( flag, flags )
    flags[ :no_change ] = false unless flag.nil?
    flags[ :no_errors ] = false if flag == false
    flags
  end

  def settings_params
    params.permit(
      :authenticity_token, :commit, :_method, settings: {}
    )[ :settings ]
  end
end
