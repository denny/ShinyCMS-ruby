# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for pages - ShinyPages plugin for ShinyCMS
  class Admin::PagesController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    before_action :stash_new_page, only: %i[ new create ]
    before_action :stash_page,     only: %i[ edit update destroy ]

    helper_method :with_html_editor?

    def index
      authorize Page
      authorize Section

      @top_level_items = Page.all_top_level_items

      @top_level_items.collect { |item| authorize item }
    end

    # Endpoint for drag-to-sort of pages and sections (on admin index view)
    def sort
      authorize Section, :edit?

      params[ :sorted ].each.with_index( 1 ) do |item_id, index|
        if section_id?( item_id )
          Section.find( extract_section_id( item_id ) ).update!( position: index )
        else
          Page.find( item_id ).update!( position: index )
        end
      end

      head :ok
    end

    def new
      authorize @page
    end

    def create
      authorize @page

      if @page.save
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @page
    end

    def update
      authorize @page

      if sort_elements && @page.update( strong_params )
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorize @page

      flash[ :notice ] = t( '.success' ) if @page.destroy

      redirect_to shiny_pages.pages_path
    end

    private

    def stash_new_page
      @page = Page.new( strong_params )
    end

    def stash_page
      @page = Page.find( params[:id] )
    end

    def strong_params
      return if params[ :page ].blank?

      # rubocop:disable Layout/LineLength
      params.expect(
        page: %i[
          internal_name public_name slug description template_id section_id position show_on_site show_in_menus elements_attributes: {}
        ]
      )
      # rubocop:enable Layout/LineLength
    end

    def sort_elements
      return true unless current_user.can? :edit, :page_templates

      return true unless ( new_order = params[ :sort_order ] )

      sort_order = parse_sortable_param( new_order, :sorted )

      apply_sort_order( @page.elements, sort_order )
    end

    def section_id?( item_id )
      item_id.to_s.start_with? 'section'
    end

    def extract_section_id( section_string )
      section_string.sub( %r{^section}, '' ).to_i
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def with_html_editor?
      action_name == 'edit'
    end
  end
end
