# Controller for user features not provided by Devise - profile pages, etc
class Users::SessionsController < Devise::SessionsController
  before_action :no_login, unless: lambda {
    Setting.yes?( I18n.t( 'settings.features.users.can_login' ) )
  }

  private

  def no_login
    redirect_to root_path, alert: I18n.t( 'users.alerts.no_login' )
  end
end
