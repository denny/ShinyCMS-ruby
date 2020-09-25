# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for pages - ShinyPages plugin for ShinyCMS
  class Admin::PagesController < AdminController
    helper_method :load_html_editor?

    def index
      authorise ShinyPages::Page
      authorise ShinyPages::Section
      @top_level_items = ShinyPages::Page.all_top_level_items
      @top_level_items.each do |item|
        authorise item
      end
    end

    def new
      @page = ShinyPages::Page.new
      authorise @page
    end

    def create
      @page = ShinyPages::Page.new( page_params )
      authorise @page

      if @page.save
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @page = ShinyPages::Page.find( params[:id] )
      authorise @page
    end

    def update
      @page = ShinyPages::Page.find( params[:id] )
      authorise @page

      if @page.update( page_params )
        redirect_to shiny_pages.edit_page_path( @page ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      page = ShinyPages::Page.find( params[:id] )
      authorise page

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
