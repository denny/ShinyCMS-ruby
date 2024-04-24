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
      session = Stripe::Checkout::Session.create({
        line_items: [{
          # Defined in Stripe dashboard
          price: 'price_1P95l11WqvNwCyjvpDDVpMdh',
          quantity: 1,
        }],
        mode: 'payment',
        success_url: main_app.root_url,
        cancel_url:  main_app.root_url,
      })
      redirect_to session.url, status: 303
    end

    private

    # def strong_params
      # params.permit( :year, :month, :slug, :page, :count, :size, :per )
    # end

    # def check_feature_flags
      # enforce_feature_flags :shop
    # end
  end
end
