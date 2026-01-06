# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Main site controller for form handlers, provided by ShinyForms plugin for ShinyCMS
  class FormsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    include ShinyCMS::WithAkismet
    include ShinyCMS::WithRecaptcha

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
      return true if recaptcha_not_required?

      verify_invisible_recaptcha( 'forms' ) || verify_checkbox_recaptcha
    end

    def recaptcha_not_required?
      return true unless @form.use_recaptcha?
      return true unless feature_enabled? :recaptcha_for_forms

      user_signed_in?
    end

    def passed_akismet?
      return true if akismet_not_required?

      spam, _blatant = akismet_check( request, form_data )

      !spam
    end

    def akismet_not_required?
      return true unless @form.use_akismet?
      return true unless akismet_api_key_is_set? && feature_enabled?( :akismet_for_forms )

      user_signed_in?
    end

    def redirect_after_success( notice )
      if @form.redirect_to.present?
        redirect_to @form.redirect_to, notice: notice
      else
        redirect_back_or_to main_app.root_path, notice: notice
      end
    end

    def set_form
      @form = Form.find_by( slug: params[:slug] )
    end

    def form_data
      # The perils of writing a generic form handler; calling .permit! here allows any and all params through.
      # Why even bother using strong params, in that case? Because a bunch of other stuff expects/requires it :)
      params.require( :shiny_form ).permit!
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms
    end
  end
end
