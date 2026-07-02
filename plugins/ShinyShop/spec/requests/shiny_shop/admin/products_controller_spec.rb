# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop admin features
RSpec.describe ShinyShop::Admin::ProductsController, type: :request do
  before do
    admin = create :product_admin
    sign_in admin
  end

  describe 'GET /admin/products' do
    it 'fetches the list of products in the admin area' do
      product = create :product

      get shiny_shop.products_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase

      expect( response.body ).to have_css 'td', text: product.internal_name
    end
  end

  describe 'GET /admin/shop/product/new' do
    it 'loads the form to add a new product' do
      get shiny_shop.new_product_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.new.title' ).titlecase
    end
  end

  describe 'POST /admin/shop/product/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_shop.products_path, params: {
        product: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_shop.admin.products.create.failure' )
    end

    it 'adds a new product when the form is submitted' do
      stripe_price = Stripe::Price.construct_from( id: 123, product: 'price_MOCK' )

      template = create :product_template

      allow( Stripe::Price ).to receive( :create ).and_return( stripe_price )

      post shiny_shop.products_path, params: {
        product: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id:   template.id,
          price:         1234  # 1234p === $12.34
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_product_path( ShinyShop::Product.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.create.success' )
    end
  end

  describe 'GET /admin/shop/product/:id' do
    it 'loads the form to edit an existing product' do
      product = create :product

      get shiny_shop.edit_product_path( product )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/shop/product/:id' do
    it 'fails to update the product when submitted with a blank name' do
      product = create :product

      put shiny_shop.product_path( product ), params: {
        product: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_shop.admin.products.update.failure' )
    end

    it 'updates the product when the form is submitted' do
      product = create :product

      allow( Stripe::Product ).to receive( :update )

      put shiny_shop.product_path( product ), params: {
        product: {
          internal_name: 'Updated by test'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_product_path( product )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.update.success' )
      expect( response.body ).to have_field 'product_internal_name', with: 'Updated by test'
    end

    it 'recreates the slug if it is wiped before submitting an update' do
      product = create :product
      old_slug = product.slug

      allow( Stripe::Product ).to receive( :update )

      put shiny_shop.product_path( product ), params: {
        product: {
          internal_name: 'Updated by test',
          slug:          ''
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_shop.edit_product_path( product )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.update.success' )
      expect( response.body ).to     have_field 'product_slug', with: 'updated-by-test'
      expect( response.body ).not_to have_field 'product_slug', with: old_slug
    end
  end

  describe 'PUT /admin/shop/product/delete/:id' do
    it 'archives the specified product' do
      p1 = create :product, active: true
      p2 = create :product, active: true
      p3 = create :product, active: true

      allow( Stripe::Product ).to receive( :update )

      # soft delete
      put shiny_shop.archive_product_path( p2 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_shop.admin.products.archive.success' )
      expect( response.body ).to have_css 'td', text: p1.internal_name
      expect( response.body ).to have_button I18n.t( 'shiny_shop.admin.products.index.revive' )
      expect( response.body ).to have_css 'td', text: p3.internal_name
    end
  end

  describe 'PUT /admin/shop/product/revive/:id' do
    it 'revives the specified product' do
      p1 = create :product

      allow( Stripe::Product ).to receive( :update )

      # undo soft-delete
      put shiny_shop.revive_product_path( p1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_shop.admin.products.revive.success' )
      expect( response.body ).to have_button I18n.t( 'shiny_shop.admin.products.index.archive' )
      expect( response.body ).to have_css 'td', text: p1.internal_name
    end
  end
end
