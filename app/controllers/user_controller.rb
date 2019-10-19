# Controller for user features not provided by Devise - profile pages, etc
class UserController < ApplicationController
  def index
    if user_signed_in?
      @user_profile = User.find_by( username: current_user.username )
      render :show
    else
      redirect_to user_login_path
    end
  end

  def show
    @user_profile = User.find_by( username: params[ :username ] )
  end
end
