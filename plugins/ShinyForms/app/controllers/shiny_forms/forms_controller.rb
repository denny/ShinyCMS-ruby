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
    before_action :check_feature_flags
    before_action :set_form, only: %i[ process_form ]

    # POST /forms/:slug
    def process_form
      if @form.present?
        if @form.send_to_handler( form_data )
          redirect_after_success( @form.success_message || t( '.success' ) )
        else
          redirect_to main_app.root_path, alert: t( '.failure' )
        end
      else
        redirect_to main_app.root_path, alert: t( '.form_not_found' )
      end
    end

    private

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
