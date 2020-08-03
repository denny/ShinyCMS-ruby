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
        if @form.redirect_to.present?
          redirect_to @form.redirect_to
        else
          redirect_back fallback: root_path
        end
      else
        redirect_with_alert root_path, t( '.failure' )
      end
    end

    private

    def set_form
      @form = ShinyForms::Form.find_by( slug: params[:slug] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_with_alert root_path, t( '.not_found' )
    end

    def form_data
      params.require( :shiny_form )
    end
  end
end
