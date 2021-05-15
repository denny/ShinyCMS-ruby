# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for template elements - ShinyPages plugin for ShinyCMS
  class Admin::Templates::ElementsController < AdminController
    def create
      authorize template

      flash[:notice] = t( '.success' ) if new_element.save

      redirect_to shiny_pages.edit_template_path( template )
    end

    def destroy
      authorize template

      flash[:notice] = t( '.success' ) if element.destroy

      redirect_to shiny_pages.edit_template_path( template )
    end

    private

    def template
      ShinyPages::Template.find( params[:template_id] )
    end

    def element
      template.elements.find( params[:id] )
    end

    def new_element
      template.elements.new( strong_params )
    end

    def strong_params
      params.require( :new_template_element ).permit( :name, :element_type, :content )
    end
  end
end
