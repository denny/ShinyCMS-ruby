# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop
RSpec.describe ShinyShop::ProductsController, type: :request do
  context 'without any live products in the database' do
    describe 'GET /products (none defined)' do
      it 'finds no products to display' do
        get shiny_shop.products_index_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end

    describe 'GET /products (none live)' do
      it 'finds no live products to display' do
        create :product  # Inactive, by default

        get shiny_shop.products_index_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end
  end

  context 'with live products in the database' do
    describe 'GET /products' do
      it 'fetches the list of products' do
        create :product, active: true
        product2 = create :product
        product3 = create :product, active: true

        get shiny_shop.products_index_path

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_shop.products.index.title' ).titlecase

        expect( response.body ).not_to have_css 'h2', text: product2.name
        expect( response.body ).to     have_css 'h2', text: product3.name
      end
    end

    describe 'GET /products/:slug' do
      it 'views a product' do
        product = create( :product, active: true )

        get shiny_shop.show_product_path( product.slug )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title product.name

        expect( response.body ).to have_css 'h2', text: product.name
      end

      it 'thanks user after successful checkout' do
        customer_name = Faker::Books::CultureSeries.unique.culture_ship
        stripe_session = Stripe::Checkout::Session.construct_from(
          id:               'testsession',
          customer_details: { name: customer_name }
        )
        allow( Stripe::Checkout::Session ).to receive( :retrieve ).with( 'testsession' ).and_return( stripe_session )
        product = create( :product, active: true )

        get shiny_shop.show_product_path( product.slug, session_id: 'testsession' )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shiny_shop.show_product_path( product.slug )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_text "Thank you for your order, #{customer_name}"
      end
    end
  end
end
