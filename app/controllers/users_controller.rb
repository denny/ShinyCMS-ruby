# Controller for user features not provided by Devise - profile pages, etc
class UsersController < ApplicationController
  before_action :check_feature_flags, only: %i[ show ]

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

  private

  def check_feature_flags
    enforce_feature_flags I18n.t( 'feature.user_profiles' )
  end
end
