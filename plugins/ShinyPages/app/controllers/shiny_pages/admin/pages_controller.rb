# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for pages - ShinyPages plugin for ShinyCMS
  class Admin::PagesController < AdminController
    include ShinySortable

    helper_method :load_html_editor?

    def index
      authorize ShinyPages::Page
      authorize ShinyPages::Section
      @top_level_items = ShinyPages::Page.all_top_level_items
      @top_level_items.each do |item|
        authorize item
      end
    end

    def new
      @page = ShinyPages::Page.new
      authorize @page
    end

    def create
      @page = ShinyPages::Page.new( page_params )
      authorize @page

      if @page.save
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @page = ShinyPages::Page.find( params[:id] )
      authorize @page
    end

    def update
      @page = ShinyPages::Page.find( params[:id] )
      authorize @page

      if sort_elements && @page.update( page_params )
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def sort_elements
      return true if params[ :sort_order ].blank?
      return true unless current_user.can? :edit, :page_templates

      sort_order = parse_sortable_param( params[ :sort_order ], :sorted )
      apply_sort_order( @page.elements, sort_order )
    end

    def sort_pages_and_sections
      authorize Section, :edit?

      params[ :sorted ].each_with_index do |item_id, index|
        if item_id.to_s.start_with? 'section'
          item_id = item_id.to_s.sub( %r{^section}, '' ).to_i
          Section.find( item_id ).update!( position: index + 1 )
        else
          Page.find( item_id ).update!( position: index + 1 )
        end
      end
      head :ok
    end

    def destroy
      page = ShinyPages::Page.find( params[:id] )
      authorize page

      flash[ :notice ] = t( '.success' ) if page.destroy
      redirect_to shiny_pages.pages_path
    rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
      skip_authorization
      redirect_to shiny_pages.pages_path, alert: t( '.failure' )
    end

    private

    def page_params
      params.require( :page ).permit(
        :internal_name, :public_name, :slug, :description, :template_id, :section_id,
        :position, :show_on_site, :show_in_menus, elements_attributes: {}
      )
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def load_html_editor?
      action_name == 'edit'
    end
  end
end
