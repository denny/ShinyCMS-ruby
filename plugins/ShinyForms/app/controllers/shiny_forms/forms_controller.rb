# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # Provides some useful generic endpoints to post a form to
  class FormsController < ApplicationController
    before_action :set_form, only: %i[ process_form ]

    # POST /forms/:slug
    def process_form
      if @form.send_to_handler( form_data )
        flash[ :notice ] = @form.success_message || t( '.success' )
        redirect_after_processing
      else
        flash[ :alert ] = t( '.failure' )
        redirect_to main_app.root_path
      end
    end

    private

    def redirect_after_processing
      if @form.redirect_to.present?
        redirect_to @form.redirect_to
      else
        redirect_back fallback_location: main_app.root_path
      end
    end

    def set_form
      @form = ShinyForms::Form.find_by( slug: params[:slug] )
    end

    def form_data
      params.require( :shiny_form )
    end
  end
end
