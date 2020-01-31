# Controller for user features not provided by Devise - profile pages, etc
class UsersController < ApplicationController
  before_action :check_feature_flags, only: %i[ show ]

  def index
    if user_signed_in?
      redirect_to user_profile_path( current_user.username )
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @user_profile = User.find_by( username: params[ :username ] )
    return if @user_profile

    flash[ :alert ] = 'User not found'
    redirect_to root_path
  end

  private

  def check_feature_flags
    enforce_feature_flags :user_profiles
  end
end
