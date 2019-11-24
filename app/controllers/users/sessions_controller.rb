# Controller for user features not provided by Devise - profile pages, etc
class Users::SessionsController < Devise::SessionsController
  before_action :logins_not_enabled, unless: lambda {
    Setting.yes?( I18n.t( 'settings.features.users.login' ) )
  }

  private

  def logins_not_enabled
    redirect_to root_path, alert: I18n.t( 'users.logins_off' )
  end
end
