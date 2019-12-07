# Controller for user features not provided by Devise - profile pages, etc
class Users::SessionsController < Devise::SessionsController
  before_action :check_feature_flags

  private

  def check_feature_flags
    enforce_feature_flags I18n.t( 'features.user_login' )
  end
end
