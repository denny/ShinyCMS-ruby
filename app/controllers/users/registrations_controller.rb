# Controller to tweak Devise-based user registration features
class Users::RegistrationsController < Devise::RegistrationsController
  include RecaptchaHelper

  before_action :check_feature_flags, only: %i[ new create ]
  before_action :stash_recaptcha_keys

  def new
    super
  end

  def create
    invisible_success = verify_invisible_recaptcha( 'registration' )
    checkbox_success  = verify_checkbox_recaptcha unless invisible_success

    if invisible_success || checkbox_success
      super
    else
      flash[ :show_checkbox_recaptcha ] = true
      flash[ :username ] = params[ :username ]
      flash[ :email    ] = params[ :email    ]
      redirect_to action: :new
    end
  end

  protected

  def after_update_path_for( _resource )
    edit_user_registration_path
  end

  def stash_recaptcha_keys
    @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
  end

  def check_feature_flags
    enforce_feature_flags :user_registration
  end
end
