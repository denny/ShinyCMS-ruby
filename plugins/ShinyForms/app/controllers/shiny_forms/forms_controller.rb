# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # Provides some useful generic endpoints to post a form to
  class FormsController < ApplicationController
    before_action :set_form, only: %i[ process ]

    # POST /forms/:slug
    def process
      if ShinyForms::FormHandler.respond_to? @form.handler
        ShinyForms::FormHandler.public_send( @form.handler.symbolize, shiny_form_params )
      else
        Rails.logger.warn "Unknown form handler (form ID: #{@form.id})"
        head :bad_request
      end
    end

    private

    def set_form
      @form = ShinyForms::Form.find_by( params[:slug] )
    end

    def shiny_form_params
      params.require( :shiny_form ).permit( {} )
    end
  end
end
