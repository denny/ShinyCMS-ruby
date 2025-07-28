# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Admin controller for page elements - ShinyPages plugin for ShinyCMS
  class Admin::Products::ElementsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def create
      authorize product

      flash[:notice] = t( '.success' ) if new_element.save

      redirect_to shiny_shop.edit_product_path( product )
    end

    def destroy
      authorize product

      flash[:notice] = t( '.success' ) if element.destroy

      redirect_to shiny_shop.edit_product_path( product )
    end

    private

    def product
      ShinyShop::Product.find( params[:product_id] )
    end

    def element
      product.elements.find( params[:id] )
    end

    def new_element
      product.elements.new( strong_params )
    end

    def strong_params
      params.expect( new_element: %i[ name element_type content ] )
    end
  end
end
