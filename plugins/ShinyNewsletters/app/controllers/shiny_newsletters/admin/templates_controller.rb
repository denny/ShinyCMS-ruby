# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter templates - part of ShinyNewsletters plugin for ShinyCMS
  class Admin::TemplatesController < AdminController
    def index
      authorise Template

      page_num = params[ :page ] || 1

      @templates = Template.order( :name ).page( page_num )
      authorise @templates if @templates.present?
    end

    def new
      @template = Template.new
      authorise @template
    end

    def create
      @template = Template.new( template_params )
      authorise @template

      if @template.save
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @template = Template.find( params[:id] )
      authorise @template
    end

    def update
      @template = Template.find( params[:id] )
      authorise @template

      if @template.update( template_params )
        redirect_to shiny_newsletters.edit_template_path( @template ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def destroy
      template = Template.find( params[:id] )
      authorise template

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
