# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Admin controller for shop products - ShinyShop plugin for ShinyCMS
  class Admin::ProductsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithSorting

    helper_method :with_html_editor?

    def index
      authorize Product

      @products = Product.all
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

      if @product.update_with_stripe( strong_params.except :price )
        redirect_to shiny_shop.edit_product_path( @product ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorize @product

      flash[ :notice ] = t( '.success' ) if @product.archive_with_stripe
      redirect_to shiny_shop.products_path
    end

    private

    def with_html_editor?
      action_name == :index
    end

    def strong_params
      params.require( :product ).permit(
        :internal_name, :public_name, :slug, :description, :position, :show_on_site, :active, :price
      )
    end
  end
end
