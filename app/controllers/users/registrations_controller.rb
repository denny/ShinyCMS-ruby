# Controller to tweak Devise-based user registration features
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_feature_flags, only: %i[ new create ]

  def new
    super
  end

  def create
    super
  end

  protected

  def after_update_path_for( _resource )
    user_edit_path
  end

  def check_feature_flags
    enforce_feature_flags I18n.t( 'feature.user_registration' )
  end
end
