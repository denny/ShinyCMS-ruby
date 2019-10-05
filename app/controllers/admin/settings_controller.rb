# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  # Render site settings form
  def index
    @settings = Setting.order( :name )
  end

  # New setting form submitted
  def create
    @setting = Setting.new( setting_params )

    if @setting.save
      flash[ :notice ] = 'New setting added'
    else
      flash[ :alert ] = 'Failed to create new setting'
    end
    redirect_to admin_settings_path
  end

  # Main form submitted; update any changed settings
  def update
    flash[ :status ] = 'Settings updated'
    redirect_to admin_settings_path
  end

  def delete
    if Setting.delete( params[ :id ] )
      flash[ :notice ] = 'Setting deleted'
    else
      flash[ :alert ] = 'Failed to delete setting'
    end
    redirect_to admin_settings_path
  end

  private

  def setting_params
    params.require( :setting ).permit( :name, :value )
  end
end
