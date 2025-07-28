# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Admin controller for sections - ShinyShop plugin for ShinyCMS
  class Admin::SectionsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    # Redirect to the combined product+section list
    def index
      authorize ShinyShop::Section
      redirect_to shiny_shop.products_path
    end

    def new
      @section = ShinyShop::Section.new
      authorize @section
    end

    def create
      @section = ShinyShop::Section.new( section_params )
      authorize @section

      if @section.save
        redirect_to shiny_shop.edit_section_path( @section ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @section = ShinyShop::Section.find( params[:id] )
      authorize @section
    end

    def update
      @section = ShinyShop::Section.find( params[:id] )
      authorize @section

      if @section.update( section_params )
        redirect_to shiny_shop.edit_section_path( @section ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      section = ShinyShop::Section.find( params[:id] )
      authorize section

      flash[ :notice ] = t( '.success' ) if section.destroy
      redirect_to shiny_shop.products_path
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_shop.products_path, alert: t( '.failure' )
    end

    private

    def section_params
      params.expect(
        section: %i[ internal_name public_name slug description section_id position show_on_site show_in_menus ]
      )
    end
  end
end
