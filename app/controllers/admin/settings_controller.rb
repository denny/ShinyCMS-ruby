# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  def index
    @settings = Setting.order( :name )
    authorise @settings
  end

  def update
    skip_authorization # TODO: this is obviously bad; refactoring v. soon!

    all_updated = update_settings( settings_params )
    if all_updated
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to settings_path
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
