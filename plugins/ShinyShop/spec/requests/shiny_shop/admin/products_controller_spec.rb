# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop admin features
RSpec.describe ShinyShop::Admin::ProductsController, type: :request do
  before do
    admin = create :shop_admin
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
      template = create :product_template

      post shiny_shop.products_path, params: {
        product: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id:   template.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_product_path( ShinyShop::Item.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.create.success' )
    end

    it 'adds a new product with elements from template' do
      template = create :product_template

      post shiny_shop.products_path, params: {
        product: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id:   template.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_product_path( ShinyItems::Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.create.success' )
      expect( response.body ).to have_css 'label', text:  template.elements.first.name.humanize
      expect( response.body ).to have_css 'label', text: template.elements.last.name.humanize
    end
  end

  describe 'GET /admin/shop/product/:id' do
    it 'loads the form to edit an existing product' do
      product = create :product, :with_content

      get shiny_shop.edit_product_path( product )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
    end

    it 'shows the appropriate input type for each element type' do
      product = create :product_with_element_type_content

      get shiny_shop.edit_product_path( product )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase

      expect( response.body ).to have_field 'product[elements_attributes][0][image]',   type: 'file'
      expect( response.body ).to have_field 'product[elements_attributes][1][content]', type: 'text',     with: 'SHORT!'
      expect( response.body ).to have_field 'product[elements_attributes][2][content]', type: 'textarea', with: 'LONG!'
      expect( response.body ).to have_field 'product[elements_attributes][3][content]', type: 'textarea', with: 'HTML!'
      cke_regex = %r{<textarea [^>]*id="(?<cke_id>product_elements_attributes_\d+_content)"[^>]*>\nHTML!</textarea>}
      matches = response.body.match cke_regex
      expect( response.body ).to include "CKEDITOR.replace('#{matches[:cke_id]}'"
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

    it 'updates the element order' do
      template_admin = create :product_template_admin
      sign_in template_admin

      product = create :product
      last_element = product.elements.last

      # Put the last element first
      ids = product.elements.ids
      last_id = ids.pop
      ids.unshift last_id

      query_string = ''
      ids.each do |id|
        query_string += "sorted[]=#{id}&"
      end

      expect( last_element.position ).to eq ids.size

      put shiny_shop.product_path( product ), params: {
        product: {
          internal_name: product.internal_name
        }
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.products.update.success' )

      expect( last_element.reload.position ).to eq 1
    end
  end

  describe 'DELETE /admin/shop/product/delete/:id' do
    it 'deletes the specified product' do
      p1 = create :product
      p2 = create :product
      p3 = create :product

      delete shiny_shop.product_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_shop.admin.products.destroy.success' )
      expect( response.body ).to     have_css 'td', text: p1.internal_name
      expect( response.body ).not_to have_css 'td', text: p2.internal_name
      expect( response.body ).to     have_css 'td', text: p3.internal_name
    end
  end

  describe 'PUT /admin/products/sort' do
    it 'sorts the products and sections as requested' do
      s1 = create :product_section, position: 1
      p2 = create :product, section: s1, position: 2
      p3 = create :product, position: 3
      s4 = create :product_section, position: 4
      p5 = create :product, position: 5

      put shiny_shop.sort_products_path, params: {
        sorted: [
          p2.id,
          "section#{s4.id}",
          "section#{s1.id}",
          p5.id,
          p3.id
        ]
      }

      expect( response ).to have_http_status :ok

      expect( s1.reload.position ).to eq 3
      expect( p2.reload.position ).to eq 1
      expect( p3.reload.position ).to eq 5
      expect( s4.reload.position ).to eq 2
      expect( p5.reload.position ).to eq 4
    end
  end
end
