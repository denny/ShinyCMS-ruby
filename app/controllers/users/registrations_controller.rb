# Controller to tweak Devise-based user registration features
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :no_registration, only: %i[ new create ], unless: lambda {
    Setting.yes?( I18n.t( 'settings.features.users.can_register' ) )
  }

  protected

  def after_update_path_for( _resource )
    user_edit_path
  end

  def no_registration
    redirect_to root_path, alert: I18n.t( 'users.alerts.no_registration' )
  end
end
