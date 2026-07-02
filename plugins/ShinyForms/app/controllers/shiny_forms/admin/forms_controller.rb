# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Admin area controller for ShinyForms plugin for ShinyCMS
  class Admin::FormsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    before_action :set_form_for_create, only: %i[ create ]
    before_action :set_form, only: %i[ edit update destroy ]
    before_action :set_form_handlers, only: %i[ new create edit update ]

    def index
      authorize Form

      @pagy, @forms = pagy( Form.all )

      authorize @forms if @forms.present?
    end

    def search
      authorize Form

      @pagy, @forms = pagy( Form.admin_search( params[:q] ) )

      authorize @forms if @forms.present?
      render :index
    end

    def new
      @form = Form.new
      authorize @form
    end

    def create
      authorize @form

      if @form.save
        redirect_to edit_form_path( @form ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :new
      end
    end

    def edit
      authorize @form
    end

    def update
      authorize @form

      if @form.update( form_params )
        redirect_to edit_form_path( @form ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      authorize @form

      @form.destroy!
      redirect_to forms_path, notice: t( '.success' )
    end

    private

    def set_form
      @form = ShinyForms::Form.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to forms_path, alert: t( 'shiny_forms.admin.forms.set_form.not_found' )
    end

    def set_form_for_create
      @form = Form.new( form_params )
    end

    def set_form_handlers
      handlers = ShinyForms::FormHandler::FORM_HANDLERS

      @form_handlers =
        handlers.collect do |handler|
          [ I18n.t( "shiny_forms.admin.forms.handlers.#{handler}" ), handler ]
        end
    end

    def form_params
      params.expect(
        form: %i[ internal_name public_name slug description handler email_to filename redirect_to success_message ]
      )
    end
  end
end
