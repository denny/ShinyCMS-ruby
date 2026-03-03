# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for using Google reCAPTCHA
  module WithRecaptcha
    def verify_checkbox_recaptcha
      return if self.class.recaptcha_checkbox_secret_key.blank?

      verify_recaptcha(
        secret_key: self.class.recaptcha_checkbox_secret_key,
        env:        Rails.env
      )
    end

    def verify_invisible_recaptcha( action = nil )
      verify_invisible_recaptcha_v3( action ) || verify_invisible_recaptcha_v2
    end

    def verify_invisible_recaptcha_v2
      return if self.class.recaptcha_v2_secret_key.blank?

      verify_recaptcha(
        secret_key: self.class.recaptcha_v2_secret_key,
        env:        Rails.env
      )
    end

    def verify_invisible_recaptcha_v3( action )
      return if self.class.recaptcha_v3_secret_key.blank?

      min_score = minimum_score( action ).to_f

      verify_recaptcha(
        action:        action,
        minimum_score: min_score,
        secret_key:    self.class.recaptcha_v3_secret_key,
        env:           Rails.env
      )
    end

    def minimum_score( action )
      Setting.get( :"recaptcha_score_for_#{action}" ) || Setting.get( :recaptcha_score_default ) || 0.5
    end
  end
end
