# Helper methods for turning CMS features on/off selectively
module RecaptchaHelper
  include MainSiteHelper

  def verify_recaptcha_v2
    verify_recaptcha(
      secret_key: ENV[ 'RECAPTCHA_V2_SECRET_KEY' ],
      site_key: ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
    )
  end

  def verify_recaptcha_v3( action, score )
    # The override is used in spec/requests/user_spec.rb
    env = ENV[ 'OVERRIDE_RAILS_ENV' ] || ENV[ 'RAILS_ENV' ]

    verify_recaptcha(
      action: action,
      minimum_score: score.to_f,
      secret_key: ENV[ 'RECAPTCHA_V3_SECRET_KEY' ],
      site_key: ENV[ 'RECAPTCHA_V3_SITE_KEY' ],
      env: env
    )
  end
end
