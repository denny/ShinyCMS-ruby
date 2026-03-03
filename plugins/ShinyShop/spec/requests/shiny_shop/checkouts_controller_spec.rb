# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop
RSpec.describe ShinyShop::CheckoutsController, type: :request do
  context 'without any live products in the database' do
    describe 'POST /checkout' do
      it 'finds no live products to purchase' do
        prod1 = create :product  # Inactive, by default

        post shiny_shop.checkout_path, params: { product: prod1.slug }

        expect( response ).to have_http_status :not_found
      end
    end
  end

  context 'with a live product in the database' do
    describe 'POST /checkout' do
      it 'redirects to Stripe checkout' do
        prod1 = create :product, active: true

        stripe_session = Stripe::Checkout::Session.construct_from(
          id:  'testsession',
          url: 'https://stripe-hosted.example.com/'
        )
        allow( Stripe::Checkout::Session ).to receive( :create ).and_return( stripe_session )

        post shiny_shop.checkout_path, params: { product: prod1.slug }

        expect( response ).to have_http_status :see_other
        expect( response ).to redirect_to 'https://stripe-hosted.example.com/'
      end
    end
  end
end
