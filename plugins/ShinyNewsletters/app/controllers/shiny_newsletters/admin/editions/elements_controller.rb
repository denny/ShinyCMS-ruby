# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter edition elements - ShinyNewsletters plugin for ShinyCMS
  class Admin::Editions::ElementsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def create
      authorize edition

      flash[:notice] = t( '.success' ) if new_element.save

      redirect_to shiny_newsletters.edit_edition_path( edition )
    end

    def destroy
      authorize edition

      flash[:notice] = t( '.success' ) if element.destroy

      redirect_to shiny_newsletters.edit_edition_path( edition )
    end

    private

    def edition
      Edition.find( params[:edition_id] )
    end

    def element
      edition.elements.find( params[:id] )
    end

    def new_element
      edition.elements.new( strong_params )
    end

    def strong_params
      params.expect( new_element: %i[ name element_type content ] )
    end
  end
end
