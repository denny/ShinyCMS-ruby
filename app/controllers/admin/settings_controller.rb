# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  before_action :check_admin_ip_whitelist

  # Display site settings form
  def index
    @settings = Setting.order( :name )
  end

  # Main form submitted; update any changed settings
  def update
    # TODO
    # flash[ :notice ] = I18n.t 'settings_updated'
    flash[ :alert ] = I18n.t 'settings_update_failed'
    redirect_to admin_settings_path
  end

  # Add a new setting item
  def create
    @setting = Setting.new( setting_params )

    if @setting.save
      flash[ :notice ] = I18n.t 'setting_created'
    else
      flash[ :alert ] = I18n.t 'setting_create_failed'
    end
    redirect_to admin_settings_path
  end

  # Delete an existing settings item
  def delete
    if Setting.delete( params[ :id ] )
      flash[ :notice ] = I18n.t 'setting_deleted'
    else
      flash[ :alert ] = I18n.t 'setting_delete_failed'
    end
    redirect_to admin_settings_path
  end

  private

  def setting_params
    params.require( :setting ).permit( :name, :value )
  end
end
