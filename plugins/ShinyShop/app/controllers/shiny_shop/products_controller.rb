# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Main site controller for shop products - provided by ShinyShop plugin for ShinyCMS
  class ProductsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    # before_action :check_feature_flags

    def index
      # TODO: show a list of all products
      # @pagy, @posts = pagy_countless( Post.readonly.recent.with_discussions )

      return unless strong_params[ :session_id ]

      session = Stripe::Checkout::Session.retrieve( strong_params[ :session_id ] )

      flash[ :notice ] = "Thank you for your order, #{session.customer_details.name}"

      redirect_to shiny_shop.products_path
    end

    def show
      @product = Product.where( show_on_site: true ).find_by( slug: params[ :slug ] )
    end

    private

    def strong_params
      params.permit( :session_id )
    end

    # def check_feature_flags
    #   enforce_feature_flags :shop
    # end
  end
end
