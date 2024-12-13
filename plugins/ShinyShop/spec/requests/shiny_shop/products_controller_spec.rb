# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
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
        get shiny_shop.products_index_path

        products = create :product  # Inactive, by default

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end
  end

  context 'with live products in the database' do
    describe 'GET /products' do
      it 'fetches the list of products' do
        product1 = create :product, active: true
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
    end
  end
end
