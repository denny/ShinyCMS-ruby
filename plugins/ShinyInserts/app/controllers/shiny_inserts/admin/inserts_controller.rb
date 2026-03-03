# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyInserts
  # Admin area controller for ShinyInserts plugin for ShinyCMS
  class Admin::InsertsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    helper_method :with_html_editor?

    before_action :stash_insert_set

    # Displays main form, for updating/deleting the existing insert,
    # and a second form at the bottom of the page to add new insert.
    def index
      authorize @insert_set
    end

    # Bottom of page form submitted; add new insert
    def create
      @new_element = @insert_set.elements.new( new_element_params )
      authorize @new_element

      if @new_element.save
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert ] = t( '.failure' )
      end
      redirect_to shiny_inserts.inserts_path
    end

    # Main form submitted; update existing insert
    def update
      authorize @insert_set

      flash[ :notice ] = t( '.success' ) if @insert_set.update( insert_params )
      redirect_to shiny_inserts.inserts_path
    rescue ActiveRecord::RecordNotUnique
      skip_authorization
      redirect_to shiny_inserts.inserts_path, alert: t( '.failure' )
    end

    def destroy
      element = @insert_set.elements.find( params[ :id ] )
      authorize element

      flash[ :notice ] = t( '.success' ) if element.destroy
      redirect_to action: :index
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_inserts.inserts_path, alert: t( '.failure' )
    end

    private

    def stash_insert_set
      @insert_set = ShinyInserts::Set.first
    end

    # Permitted params for single-item operations
    def new_element_params
      params.expect( insert_element: %i[ name content element_type ] )
    end

    # Permitted params for multi-item operations
    def insert_params
      params.expect( insert_set: [ elements_attributes: {} ] )
    end

    def with_html_editor?
      action_name == :index
    end
  end
end
