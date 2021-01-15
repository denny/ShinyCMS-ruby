# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for templates - ShinyPages plugin for ShinyCMS
  class Admin::TemplatesController < AdminController
    include ShinySortable

    before_action :stash_new_template, only: %i[ new create ]
    before_action :stash_template,     only: %i[ edit update destroy ]

    helper_method :load_html_editor?

    def index
      authorize Template

      @pagy, @templates = pagy( Template.order( :name ), items: items_per_page )

      authorize @templates if @templates.present?
    end

    def search
      authorize Template

      @pagy, @templates = pagy( Template.admin_search( params[:q] ), items: items_per_page )

      authorize @templates if @templates.present?
      render :index
    end

    def new
      authorize @template
    end

    def create
      authorize @template

      if @template.save
        redirect_to shiny_pages.edit_template_path( @template ), notice: t( '.success' )
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
        redirect_to shiny_pages.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      authorize @template

      flash[ :notice ] = t( '.success' ) if @template.destroy

      redirect_to shiny_pages.templates_path
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_pages.templates_path, alert: t( '.failure' )
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

      params.require( :template ).permit(
        :name, :description, :filename, elements_attributes: {}
      )
    end

    def sort_elements
      return true if params[ :sort_order ].blank?

      sort_order = parse_sortable_param( params[ :sort_order ], :sorted )
      apply_sort_order( @template.elements, sort_order )
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def load_html_editor?
      action_name == 'edit'
    end
  end
end
