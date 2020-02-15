# Controller to tweak Devise-based user registration features
class Users::RegistrationsController < Devise::RegistrationsController
  include RecaptchaHelper

  before_action :check_feature_flags, only: %i[ new create ]

  def new
    stash_recaptcha_key
    super
  end

  def create
    stash_recaptcha_key
    invisible_success = verify_invisible_recaptcha( 'registration' )
    checkbox_success  = verify_checkbox_recaptcha unless invisible_success

    if invisible_success || checkbox_success
      super
    else
      @show_checkbox_recaptcha = true
      render :new
    end
  end

  protected

  def after_update_path_for( _resource )
    edit_user_registration_path
  end

  def stash_recaptcha_key
    @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ] unless @recaptcha_v3_key
  end

  def check_feature_flags
    enforce_feature_flags :user_registration
  end
end
