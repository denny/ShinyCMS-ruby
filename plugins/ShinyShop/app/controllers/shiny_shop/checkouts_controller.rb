# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Main site controller for checkout - provided by ShinyShop plugin for ShinyCMS
  class CheckoutsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :check_feature_flags

    def create
      @product = ShinyShop::Product.visible.find_by!( slug: strong_params[ :product ] )

      session = Stripe::Checkout::Session.create(
        line_items:  build_line_items,
        mode:        'payment',
        success_url: "#{shiny_shop.product_or_section_url( @product.slug )}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url:  main_app.root_url
      )

      redirect_to session.url, status: :see_other, allow_other_host: true
    end

    private

    def build_line_items
      [
        {
          # Defined in Stripe dashboard
          price:    @product.stripe_price_id,
          quantity: 1
        }
      ]
    end

    def strong_params
      params.permit( :product )
    end

    def check_feature_flags
      enforce_feature_flags :shop
    end
  end
end
