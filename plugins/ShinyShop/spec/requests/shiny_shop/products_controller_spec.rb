# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop
RSpec.describe ShinyShop::ProductsController, type: :request do
  context 'without any live products in the database' do
    describe 'GET /shop (none defined)' do
      it 'finds no products to display' do
        get shiny_shop.shop_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end

    describe 'GET /shop (none live)' do
      it 'finds no live products to display' do
        create :product  # Inactive, by default

        get shiny_shop.shop_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end
  end

  context 'with live products in the database' do
    describe 'GET /shop' do
      it 'fetches the list of top-level products and sections' do
        create :product, active: true
        product2 = create :product
        product3 = create :product, active: true

        get shiny_shop.shop_path

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_shop.products.index.title' ).titlecase

        expect( response.body ).not_to have_css 'h3', text: product2.name
        expect( response.body ).to     have_css 'h3', text: product3.name
      end
    end

    describe 'GET /shop/:section' do
      it 'displays list of products in section' do
        section  = create :shop_section
        product1 = create :product, section: section, active: true
        product2 = create :product, section: section, active: true

        get shiny_shop.product_or_section_path( section.slug )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title section.name
        expect( response.body ).to have_text  product1.name
        expect( response.body ).to have_text  product2.name
      end
    end

    describe 'GET /shop/:slug' do
      it 'views a product' do
        product = create( :product, active: true )

        get shiny_shop.product_or_section_path( product.slug )

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

        get shiny_shop.product_or_section_path( product.slug, session_id: 'testsession' )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shiny_shop.show_product_path( product.slug )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_text "Thank you for your order, #{customer_name}"
      end
    end

    describe 'GET /shop/non-existent-slug', :production_error_responses do
      it 'returns a 404 if no matching product or section is found at top-level' do
        get '/shop/non-existent-slug'

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to include 'Section not found'
      end
    end

    describe 'GET /shop/existing-section/non-existent-slug', :production_error_responses do
      it 'returns a 404 if no matching product or sub-section is found in section' do
        prod1 = create :product_in_section

        get "/shop/#{prod1.section.slug}/non-existent-slug"

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to include 'Section not found'
      end
    end

    describe 'GET /shop/non-existent-section/irrelevant-slug', :production_error_responses do
      it 'returns a 404 if a page is requested in nested non-existent sections' do
        get '/shop/non-existent-section/and-another/irrelevant-slug'

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to include 'Section not found'
      end
    end

    describe 'GET /shop/not-html-404.xml', :production_error_responses do
      it 'still returns a 404 even if a non-existent non-HTML resource is requested' do
        get '/shop/not-html-404.xml'

        expect( response      ).to have_http_status :not_found
        expect( response.body ).to be_empty
      end
    end
  end
end
