# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # Main site controller for form handlers, provided by ShinyForms plugin for ShinyCMS
  class FormsController < MainController
    include AkismetHelper
    include RecaptchaHelper

    before_action :check_feature_flags
    before_action :set_form, only: %i[ process_form ]

    # POST /forms/:slug
    def process_form
      return redirect_to main_app.root_path, alert: t( '.form_not_found' ) if @form.blank?

      if passed_recaptcha_and_akismet? && @form.send_to_handler( form_data )
        redirect_after_success( @form.success_message || t( '.success' ) )
      else
        redirect_to main_app.root_path, alert: t( '.failure' )
      end
    end

    private

    def passed_recaptcha_and_akismet?
      passed_recaptcha? && passed_akismet?
    end

    def passed_recaptcha?
      return true if user_signed_in?
      return true unless feature_enabled? :recaptcha_for_forms
      return true unless @form.use_recaptcha?

      verify_invisible_recaptcha( 'form' ) || verify_checkbox_recaptcha
    end

    def passed_akismet?
      return true if user_signed_in?
      return true unless akismet_api_key_is_set? && feature_enabled?( :akismet_for_forms )
      return true unless @form.use_akismet?

      spam, _blatant = akismet_check( request, form_data )

      !spam
    end

    def redirect_after_success( notice )
      if @form.redirect_to.present?
        redirect_to @form.redirect_to, notice: notice
      else
        redirect_back fallback_location: main_app.root_path, notice: notice
      end
    end

    def set_form
      @form = ShinyForms::Form.find_by( slug: params[:slug] )
    end

    def form_data
      params.permit( :authenticity_token, :slug, shiny_form: {} )[ 'shiny_form' ]
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms
    end
  end
end
