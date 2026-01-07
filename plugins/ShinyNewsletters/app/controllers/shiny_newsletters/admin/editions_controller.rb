# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter editions - ShinyNewsletters plugin for ShinyCMS
  class Admin::EditionsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    before_action :stash_new_edition, only: %i[ new create ]
    before_action :stash_edition,     only: %i[ edit update send_sample destroy ]

    helper_method :with_html_editor?

    def index
      authorize Edition

      @pagy, @editions = pagy( Edition.order( updated_at: :desc ) )

      authorize @editions if @editions.present?
    end

    def search
      authorize Edition

      @pagy, @editions = pagy( Edition.admin_search( params[:q] ) )

      authorize @editions if @editions.present?
      render :index
    end

    def new
      authorize @edition
    end

    def create
      authorize @edition

      if @edition.save
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @edition
    end

    def update
      authorize @edition

      if sort_elements && @edition.update( strong_params )
        redirect_to shiny_newsletters.edit_edition_path( @edition ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def send_sample
      authorize @edition

      flash[ :notice ] = t( '.success' ) if @edition.send_sample( current_user )

      redirect_to shiny_newsletters.editions_path
    end

    def destroy
      authorize @edition

      if @edition.destroy
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert  ] = t( '.failure' )
      end

      redirect_to shiny_newsletters.editions_path
    end

    private

    def stash_new_edition
      @edition = Edition.new( strong_params )
    end

    def stash_edition
      @edition = Edition.find( params[:id] )
    end

    def strong_params
      return if params[ :edition ].blank?

      params.expect(
        edition: %i[
          internal_name public_name slug description template_id show_on_site elements_attributes: {}
        ]
      )
    end

    def sort_elements
      return true unless current_user.can? :edit, :newsletter_templates

      return true unless ( new_order = params[ :sort_order ] )

      sort_order = parse_sortable_param( new_order, :sorted )

      apply_sort_order( @edition.elements, sort_order )
    end

    # Return true if the page we're on might need a WYSIWYG HTML editor
    def with_html_editor?
      action_name == 'edit'
    end
  end
end
