# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for template elements - ShinyNewsletters plugin for ShinyCMS
  class Admin::Templates::ElementsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def create
      authorize template

      flash[:notice] = t( '.success' ) if new_element.save

      redirect_to shiny_newsletters.edit_template_path( template )
    end

    def destroy
      authorize template

      flash[:notice] = t( '.success' ) if element.destroy

      redirect_to shiny_newsletters.edit_template_path( template )
    end

    private

    def template
      Template.find( params[:template_id] )
    end

    def element
      template.elements.find( params[:id] )
    end

    def new_element
      template.elements.new( strong_params )
    end

    def strong_params
      params.expect( new_element: %i[ name element_type content ] )
    end
  end
end
