# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # Provides some useful generic endpoints to post a form to
  class FormsController < ApplicationController
    before_action :set_form, only: %i[ process ]

    # GET /forms
    def index
      redirect_back fallback: root_path
    end

    # POST /forms/slug
    def process
      if ShinyForms::FormHandler.respond_to? @form.handler
        ShinyForms::FormHandler.public_send( @form.handler.symbolize, params )
      else
        Rails.logger.warn "Unknown form handler (form ID: #{@form.id})"
        head :bad_request
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find_by( params[:slug] )
    end
  end
end
