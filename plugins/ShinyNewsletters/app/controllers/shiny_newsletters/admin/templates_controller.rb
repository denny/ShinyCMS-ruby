# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter templates - part of ShinyNewsletters plugin for ShinyCMS
  class Admin::TemplatesController < AdminController
    include ShinySortable

    def index
      authorize Template

      page_num = params[ :page ] || 1

      @templates = Template.order( :name ).page( page_num )
      authorize @templates if @templates.present?
    end

    def new
      @template = Template.new
      authorize @template
    end

    def create
      @template = Template.new( template_params )
      authorize @template

      if @template.save
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @template = Template.find( params[:id] )
      authorize @template
    end

    def update
      @template = Template.find( params[:id] )
      authorize @template

      if sort_elements && @template.update( template_params )
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def sort_elements
      return true if params[ :sort_order ].blank?

      sort_order = parse_sortable_param( params[ :sort_order ], :sorted )
      apply_sort_order( @template.elements, sort_order )
    end

    def destroy
      template = Template.find( params[:id] )
      authorize template

      flash[ :notice ] = t( '.success' ) if template.destroy
      redirect_to shiny_newsletters.templates_path
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to shiny_newsletters.templates_path, alert: t( '.failure' )
    end

    private

    def template_params
      params.require( :template ).permit( :name, :description, :filename, elements_attributes: {} )
    end
  end
end
