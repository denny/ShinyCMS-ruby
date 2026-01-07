# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for sections - ShinyPages plugin for ShinyCMS
  class Admin::SectionsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    # Redirect to the combined page+section list
    def index
      authorize ShinyPages::Section
      redirect_to shiny_pages.pages_path
    end

    def new
      @section = ShinyPages::Section.new
      authorize @section
    end

    def create
      @section = ShinyPages::Section.new( section_params )
      authorize @section

      if @section.save
        redirect_to shiny_pages.edit_section_path( @section ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @section = ShinyPages::Section.find( params[:id] )
      authorize @section
    end

    def update
      @section = ShinyPages::Section.find( params[:id] )
      authorize @section

      if @section.update( section_params )
        redirect_to shiny_pages.edit_section_path( @section ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      section = ShinyPages::Section.find( params[:id] )
      authorize section

      flash[ :notice ] = t( '.success' ) if section.destroy
      redirect_to shiny_pages.pages_path
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_pages.pages_path, alert: t( '.failure' )
    end

    private

    def section_params
      params.expect(
        section: %i[ internal_name public_name slug description section_id position show_on_site show_in_menus ]
      )
    end
  end
end
