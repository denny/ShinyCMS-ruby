# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Main site controller for shop products - provided by ShinyShop plugin for ShinyCMS
  class ProductsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :check_feature_flags

    def index
      @pagy, @products = pagy( Product.readonly.visible )
    end

    def show
      @product = Product.readonly.visible.find_by( slug: strong_params[ :slug ] )

      return unless strong_params[ :session_id ]

      session = retrieve_stripe_session

      flash[ :notice ] = "Thank you for your order, #{session.customer_details.name}"

      redirect_to shiny_shop.show_product_path( @product.slug )  # Clear visible session ID off end of URL
    end

    private

    def strong_params
      params.permit( :session_id, :slug )
    end

    def retrieve_stripe_session
      Stripe::Checkout::Session.retrieve( strong_params[ :session_id ] )
    end

    def check_feature_flags
      enforce_feature_flags :shop
    end
  end
end
