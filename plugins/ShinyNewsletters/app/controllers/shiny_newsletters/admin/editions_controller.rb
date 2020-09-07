# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter editions - ShinyNewsletters plugin for ShinyCMS
  class Admin::EditionsController < AdminController
    def index
      authorise Edition
      @editions = Edition.all
    end

    def new
      @edition = Edition.new
      authorise @edition
    end

    def create
      @edition = Edition.new( edition_params )
      authorise @edition

      if @edition.save
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @edition = Edition.find( params[:id] )
      authorise @edition
    end

    def update
      @edition = Edition.find( params[:id] )
      authorise @edition

      if @edition.update( edition_params )
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      edition = Edition.find( params[:id] )
      authorise edition

      flash[ :notice ] = t( '.success' ) if edition.destroy
      redirect_to shiny_newsletters.editions_path
    rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
      skip_authorization
      redirect_to shiny_newsletters.editions_path, alert: t( '.failure' )
    end

    private

    def edition_params
      params.require( :edition ).permit(
        :internal_name, :public_name, :slug, :description, :template_id, :show_on_site, elements_attributes: {}
      )
    end
  end
end
