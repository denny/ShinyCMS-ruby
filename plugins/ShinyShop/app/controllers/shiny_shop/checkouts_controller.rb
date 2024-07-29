# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Main site controller for checkout - provided by ShinyShop plugin for ShinyCMS
  class CheckoutsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    # before_action :check_feature_flags

    def create
      session = Stripe::Checkout::Session.create(
        line_items:  build_line_items,
        mode:        'payment',
        success_url: "#{shiny_shop.products_url}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url:  main_app.root_url
      )
      redirect_to session.url, status: :see_other
    end

    private

    def build_line_items
      [
        {
          # Defined in Stripe dashboard
          price:    'price_1P95l11WqvNwCyjvpDDVpMdh',
          quantity: 1
        }
      ]
    end

    # def strong_params
    #   params.permit( :year, :month, :slug, :page, :count, :size, :per )
    # end

    # def check_feature_flags
    #   enforce_feature_flags :shop
    # end
  end
end
