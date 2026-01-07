# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for page elements - ShinyPages plugin for ShinyCMS
  class Admin::Pages::ElementsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def create
      authorize page

      flash[:notice] = t( '.success' ) if new_element.save

      redirect_to shiny_pages.edit_page_path( page )
    end

    def destroy
      authorize page

      flash[:notice] = t( '.success' ) if element.destroy

      redirect_to shiny_pages.edit_page_path( page )
    end

    private

    def page
      ShinyPages::Page.find( params[:page_id] )
    end

    def element
      page.elements.find( params[:id] )
    end

    def new_element
      page.elements.new( strong_params )
    end

    def strong_params
      params.expect( new_element: %i[ name element_type content ] )
    end
  end
end
