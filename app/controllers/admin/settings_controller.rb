# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  # after_action :verify_authorized

  def index
    @settings = Setting.order( :name )
  end

  def create
    setting = Setting.new( setting_params )

    if setting.save
      flash[ :notice ] = I18n.t 'admin.settings.setting_created'
    else
      flash[ :alert ] = I18n.t 'admin.settings.setting_create_failed'
    end
    redirect_to admin_settings_path
  end

  # Main form submitted; update any changed settings and report back
  def update
    updated_settings = false
    updated_settings = update_settings( updated_settings )
    flash[ :notice ] =
      if updated_settings
        I18n.t 'admin.settings.settings_updated'
      else
        I18n.t 'admin.settings.settings_unchanged'
      end
    redirect_to admin_settings_path
  end

  def delete
    if Setting.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.settings.setting_deleted'
    end
    redirect_to admin_settings_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.settings.setting_delete_failed'
    redirect_to admin_settings_path
  end

  private

  # Process the batched settings update
  def update_settings( flag )
    settings = settings_params[ :settings ]
    settings&.each_key do |key|
      next unless /setting_value_(?<id>\d+)/ =~ key

      value = settings[ "setting_value_#{id}" ]
      description = settings[ "setting_description_#{id}" ]

      setting = Setting.find( id )
      next if setting.value == value && setting.description == description

      flag = setting.update! value: value, description: description
    end
    flag
  end

  def setting_params
    params.require( :setting ).permit( :name, :value, :description )
  end

  def settings_params
    params.permit( :authenticity_token, :commit, settings: {} )
  end
end
