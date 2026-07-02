# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Admin controller for shop products - ShinyShop plugin for ShinyCMS
  class Admin::ProductsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    # before_action :stash_new_page, only: %i[ new create ]
    # before_action :stash_page,     only: %i[ edit update destroy ]

    helper_method :with_html_editor?

    def index
      authorize Product
      authorize Section

      @top_level_items = Product.all_top_level_items

      @top_level_items.collect { |item| authorize item }

      @products = Product.order( 'lower(internal_name)' )
    end

    def new
      @product = Product.new
      authorize @product
    end

    def create
      @product = Product.new strong_params
      authorize @product

      if @product.create_with_stripe
        redirect_to shiny_shop.edit_product_path( @product ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @product = Product.find( params[:id] )
      authorize @product
    end

    def update
      @product = Product.find( params[:id] )
      authorize @product

      if @product.update_with_stripe( strong_params.except( :price ) )
        redirect_to shiny_shop.edit_product_path( @product ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def revive
      @product = Product.find( params[:id] )
      authorize @product

      flash[ :notice ] = t( '.success' ) if @product.revive_with_stripe
      redirect_to shiny_shop.products_path
    end

    def archive
      @product = Product.find( params[:id] )
      authorize @product

      flash[ :notice ] = t( '.success' ) if @product.archive_with_stripe
      redirect_to shiny_shop.products_path
    end

    private

    def with_html_editor?
      %w[ create edit ].include? action_name
    end

    def strong_params
      params.expect(
        product: %i[
          internal_name public_name slug description section_id template_id position show_on_site active price
        ]
      )
    end
  end
end
