# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Admin controller for templates - ShinyPages plugin for ShinyCMS
  class Admin::TemplatesController < AdminController
    helper_method :load_html_editor?

    def index
      authorize ShinyPages::Template

      page_num = params[ :page ] || 1

      @templates = ShinyPages::Template.order( :name ).page( page_num )
      authorize @templates if @templates.present?
    end

    def new
      @template = ShinyPages::Template.new
      authorize @template
    end

    def create
      @template = ShinyPages::Template.new( template_params )
      authorize @template

      if @template.save
        redirect_to shiny_pages.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @template = ShinyPages::Template.find( params[:id] )
      authorize @template
    end

    def update
      @template = ShinyPages::Template.find( params[:id] )
      authorize @template

      if @template.update( template_params )
        redirect_to shiny_pages.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def sort_elements
      template = TemplateElement.find( params[ :element ].first ).template
      authorize template, :edit?

      params[ :element ].each_with_index do |element_id, index|
        TemplateElement.find( element_id ).update!( position: index + 1 )
      end
      head :ok
    end

    def destroy
      template = ShinyPages::Template.find( params[:id] )
      authorize template

      flash[ :notice ] = t( '.success' ) if template.destroy
      redirect_to shiny_pages.templates_path
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_pages.templates_path, alert: t( '.failure' )
    end

    private

    def template_params
      params.require( :template ).permit(
        :name, :description, :filename, elements_attributes: {}
      )
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def load_html_editor?
      action_name == 'edit'
    end
  end
end
