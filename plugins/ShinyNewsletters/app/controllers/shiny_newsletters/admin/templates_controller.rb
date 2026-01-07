# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter templates - part of ShinyNewsletters plugin for ShinyCMS
  class Admin::TemplatesController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    before_action :stash_new_template, only: %i[ new create ]
    before_action :stash_template,     only: %i[ edit update destroy ]

    helper_method :with_html_editor?

    def index
      authorize Template

      @pagy, @templates = pagy( Template.order( :name ) )

      authorize @templates if @templates.present?
    end

    def search
      authorize Template

      @pagy, @templates = pagy( Template.admin_search( params[:q] ) )

      authorize @templates if @templates.present?
      render :index
    end

    def new
      authorize @template
    end

    def create
      authorize @template

      if @template.save
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @template
    end

    def update
      authorize @template

      if sort_elements && @template.update( strong_params )
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      authorize @template

      if @template.destroy
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert  ] = t( '.failure' )
      end

      redirect_to shiny_newsletters.templates_path
    end

    private

    def stash_new_template
      @template = Template.new( strong_params )
    end

    def stash_template
      @template = Template.find( params[:id] )
    end

    def strong_params
      return if params[ :template ].blank?

      params.expect( template: %i[ name description filename elements_attributes: {} ] )
    end

    def sort_elements
      return true unless ( new_order = params[ :sort_order ] )

      sort_order = parse_sortable_param( new_order, :sorted )

      apply_sort_order( @template.elements, sort_order )
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def with_html_editor?
      action_name == 'edit'
    end
  end
end
