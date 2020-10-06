# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter editions - ShinyNewsletters plugin for ShinyCMS
  class Admin::EditionsController < AdminController
    include ShinySortable

    def index
      authorize Edition
      @editions = Edition.page( page_number ).per( items_per_page )
      authorize @editions if @editions.present?
    end

    def search
      authorize Edition

      q = params[:q]
      @editions = Edition.where( 'internal_name ilike ?', "%#{q}%" )
                         .or( Edition.where( 'public_name ilike ?', "%#{q}%" )
                         .or( Edition.where( 'description ilike ?', "%#{q}%" ) ) )
                         .order( updated_at: :desc )
                         .page( page_number ).per( items_per_page )

      authorize @editions if @editions.present?
      render :index
    end

    def new
      @edition = Edition.new
      authorize @edition
    end

    def create
      @edition = Edition.new( edition_params )
      authorize @edition

      if @edition.save
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @edition = Edition.find( params[:id] )
      authorize @edition
    end

    def update
      @edition = Edition.find( params[:id] )
      authorize @edition

      if sort_elements && @edition.update( edition_params )
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def sort_elements
      return true if params[ :sort_order ].blank?
      return true unless current_user.can? :edit, :newsletter_templates

      sort_order = parse_sortable_param( params[ :sort_order ], :sorted )
      apply_sort_order( @edition.elements, sort_order )
    end

    def send_sample
      edition = Edition.find( params[:id] )
      authorize edition

      flash[ :notice ] = t( '.success' ) if edition.send_sample( current_user )

      redirect_to shiny_newsletters.editions_path
    end

    def destroy
      edition = Edition.find( params[:id] )
      authorize edition

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
