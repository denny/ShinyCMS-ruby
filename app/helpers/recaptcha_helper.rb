# Helper methods for turning CMS features on/off selectively
module RecaptchaHelper
  include MainSiteHelper

  def minimum_score( action )
    name = "recaptcha_v3_#{action}_score"
    setting( name.to_sym ) || ENV[ name.capitalize ] || 0.5
  end

  def verify_checkbox_recaptcha
    # Used in spec/requests/user_spec.rb, to test fallback to checkbox
    return false if ENV[ 'FAIL_RECAPTCHA' ].present?

    # TODO: fix the tests so they can get here (might need to refactor?)
    # :nocov:
    verify_recaptcha_v2
    # :nocov:
  end

  def verify_invisible_recaptcha( action )
    # Used in spec/requests/user_spec.rb, to test fallback to checkbox
    return false if ENV[ 'FAIL_RECAPTCHA' ].present?

    return verify_recaptcha_v3( action ) if ENV[ 'RECAPTCHA_V3_SITE_KEY' ]

    verify_recaptcha_v2
  end

  def verify_recaptcha_v2
    verify_recaptcha(
      secret_key: ENV[ 'RECAPTCHA_V2_SECRET_KEY' ],
      site_key: ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
    )
  end

  def verify_recaptcha_v3( action )
    min_score = minimum_score( action ).to_f

    verify_recaptcha(
      action: action,
      minimum_score: min_score,
      secret_key: ENV[ 'RECAPTCHA_V3_SECRET_KEY' ],
      site_key: ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    )
  end
end
