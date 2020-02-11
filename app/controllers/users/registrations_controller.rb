# Controller to tweak Devise-based user registration features
class Users::RegistrationsController < Devise::RegistrationsController
  include RecaptchaHelper

  before_action :check_feature_flags, only: %i[ new create ]

  def new
    @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ] unless @recaptcha_v3_key
    super
  end

  def create
    invisible_success = verify_recaptcha_v3( 'registration', v3_min_score )
    checkbox_success  = verify_recaptcha_v2 unless invisible_success

    if invisible_success || checkbox_success
      @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
      super
    else
      @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
      render :new
    end
  end

  protected

  def v3_min_score
    ENV[ 'RECAPTCHA_V3_REGISTRATION_SCORE' ] ||
      setting( :recaptcha_v3_registration_score ) ||
      0.5
  end

  def after_update_path_for( _resource )
    edit_user_registration_path
  end

  def check_feature_flags
    enforce_feature_flags :user_registration
  end
end
