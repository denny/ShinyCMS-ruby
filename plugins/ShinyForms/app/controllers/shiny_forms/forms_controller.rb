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
      # TODO
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end
  end
end
