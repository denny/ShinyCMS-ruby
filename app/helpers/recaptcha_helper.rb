# Helper methods for using Google reCAPTCHA
module RecaptchaHelper
  include MainSiteHelper

  def verify_checkbox_recaptcha
    return if self.class.recaptcha_checkbox_secret_key.blank?

    verify_recaptcha(
      secret_key: self.class.recaptcha_checkbox_secret_key,
      env: Rails.env
    )
  end

  def verify_invisible_recaptcha( action = nil )
    verify_invisible_recaptcha_v3( action ) || verify_invisible_recaptcha_v2
  end

  def verify_invisible_recaptcha_v2
    return if self.class.recaptcha_v2_secret_key.blank?

    verify_recaptcha(
      secret_key: self.class.recaptcha_v2_secret_key,
      env: Rails.env
    )
  end

  def verify_invisible_recaptcha_v3( action )
    return if self.class.recaptcha_v3_secret_key.blank?

    min_score = minimum_score( action ).to_f

    verify_recaptcha(
      action: action,
      minimum_score: min_score,
      secret_key: self.class.recaptcha_v3_secret_key,
      env: Rails.env
    )
  end

  def minimum_score( action )
    score_for_action = "RECAPTCHA_#{action.capitalize}_SCORE"
    general_score    = 'RECAPTCHA_SCORE'

    setting( score_for_action.downcase.to_sym ) ||
      ENV[ score_for_action ]                   ||
      setting( general_score.downcase.to_sym )  ||
      ENV[ general_score ]                      ||
      0.5
  end
end
