# Helper methods for using Google reCAPTCHA
module RecaptchaHelper
  include MainSiteHelper

  def verify_checkbox_recaptcha
    verify_recaptcha_v2
  end

  def verify_invisible_recaptcha( action = nil )
    verify_recaptcha_v3( action ) || verify_recaptcha_v2
  end

  def verify_recaptcha_v2
    return if ENV['RECAPTCHA_V2_SECRET_KEY'].blank?

    verify_recaptcha(
      secret_key: ENV['RECAPTCHA_V2_SECRET_KEY'],
      env: Rails.env
    )
  end

  def verify_recaptcha_v3( action )
    return if action.blank?
    return if ENV['RECAPTCHA_V3_SECRET_KEY'].blank?

    min_score = minimum_score( action ).to_f

    verify_recaptcha(
      action: action,
      minimum_score: min_score,
      secret_key: ENV['RECAPTCHA_V3_SECRET_KEY'],
      env: Rails.env
    )
  end

  def minimum_score( action )
    score_for_action = "RECAPTCHA_V3_#{action.capitalize}_SCORE"
    general_score    = 'RECAPTCHA_V3_SCORE'

    setting( score_for_action.downcase.to_sym ) ||
      ENV[ score_for_action ]                   ||
      setting( general_score.downcase.to_sym )  ||
      ENV[ general_score ]                      ||
      0.5
  end
end
