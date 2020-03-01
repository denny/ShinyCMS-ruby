# Check whether user login feature is enabled before passing to Devise
class Users::SessionsController < Devise::SessionsController
  before_action :check_feature_flags

  private

  def check_feature_flags
    enforce_feature_flags :user_login
  end
end
