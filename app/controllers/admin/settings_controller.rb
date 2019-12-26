# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  # after_action :verify_authorized

  def index
    @settings = Setting.order( :name )
  end

  def create
    setting = Setting.new( setting_params )

    if setting.save
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to admin_settings_path
  end

  # Main form submitted; update any changed settings and report back
  def update
    updated_settings = false
    updated_settings = update_settings( updated_settings )
    if updated_settings
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to admin_settings_path
  end

  def delete
    setting = Setting.find( params[:id] )

    flash[ :notice ] = t( '.success' ) if setting.destroy
    redirect_to admin_settings_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions t( '.failure' ), admin_settings_path
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

  # Permitted params for single-item operations
  def setting_params
    params.require( :setting ).permit( :name, :value, :description )
  end

  # Permitted params for multi-item operations
  def settings_params
    params.permit( :authenticity_token, :commit, settings: {} )
  end
end
