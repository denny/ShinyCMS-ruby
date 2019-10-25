# Controller for user features not provided by Devise - profile pages, etc
class Users::SessionsController < Devise::SessionsController
  def new
    unless Setting.yes? I18n.t( 'settings.allow_user_logins' )
      redirect_to root_path, alert: I18n.t( 'users.logins_not_enabled' )
      return
    end

    super
  end
end
