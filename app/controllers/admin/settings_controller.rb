# Admin controller for CMS settings
class Admin::SettingsController < AdminController
  # Display site settings form
  def index
    @settings = Setting.order( :name )
  end

  # Main form submitted; update any changed settings
  def update
    # TODO
    flash[ :notice ] = 'Settings updated'
    redirect_to admin_settings_path
  end

  # Add a new setting item
  def create
    @setting = Setting.new( setting_params )

    if @setting.save
      flash[ :notice ] = 'New setting added'
    else
      flash[ :alert ] = 'Failed to create new setting'
    end
    redirect_to admin_settings_path
  end

  # Delete an existing settings item
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
