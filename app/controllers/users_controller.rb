# Controller for user features not provided by Devise - profile pages, etc
class UsersController < Devise::RegistrationsController
  before_action :registration_not_allowed, only: :register, unless: lambda {
    Setting.yes?( I18n.t( 'settings.features.users.register' ) )
  }

  def index
    if user_signed_in?
      redirect_to user_profile_path( current_user.username )
    else
      redirect_to user_login_path
    end
  end

  def show
    @user_profile = User.find_by( username: params[ :username ] )
  end

  protected

  def after_update_path_for( _resource )
    edit_user_registration_path
  end

  def registration_not_enabled
    redirect_to root_path, alert: I18n.t( 'users.registration_off' )
  end
end
