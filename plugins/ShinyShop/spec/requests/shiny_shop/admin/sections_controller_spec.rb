# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop section admin features
RSpec.describe ShinyShop::Admin::SectionsController, type: :request do
  before do
    admin = create :product_admin
    sign_in admin
  end

  describe 'GET /admin/shop/sections' do
    it 'redirects to the combined products+sections list' do
      get shiny_shop.sections_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
    end
  end

  describe 'GET /admin/shop/section/new' do
    it 'loads the form to add a new section' do
      get shiny_shop.new_section_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.new.title' ).titlecase
    end
  end

  describe 'POST /admin/shop/section/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_shop.sections_path, params: {
        section: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_shop.admin.sections.create.failure' )
    end

    it 'adds a new section when the form is submitted' do
      ship_name = Faker::Books::CultureSeries.unique.culture_ship

      post shiny_shop.sections_path, params: {
        section: {
          internal_name: ship_name,
          slug:          ship_name.parameterize
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_section_path( ShinyShop::Section.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.sections.create.success' )
    end
  end

  describe 'GET /admin/shop/section/:id' do
    it 'loads the form to edit an existing section' do
      section = create :shop_section

      get shiny_shop.edit_section_path( section )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/shop/section/:id' do
    it 'fails to update the section when submitted without all the details' do
      section = create :shop_section

      put shiny_shop.section_path( section ), params: {
        section: {
          internal_name: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_shop.admin.sections.update.failure' )
    end

    it 'updates the section when the form is submitted' do
      section = create :shop_section

      put shiny_shop.section_path( section ), params: {
        section: {
          internal_name: 'Updated by test'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_section_path( section )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.sections.update.success' )
      expect( response.body ).to have_field 'section[internal_name]', with: 'Updated by test'
    end

    it 'moves a top-level section inside another section' do
      section1 = create :shop_section
      section2 = create :shop_section

      put shiny_shop.section_path( section1 ), params: {
        section: {
          section_id: section2.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.edit_section_path( section1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_shop.admin.sections.update.success' )
      expect( response.body ).to have_field 'section[section_id]', with: section2.id
    end
  end

  describe 'DELETE /admin/shop/section/delete/:id' do
    it 'deletes the specified section' do
      s1 = create :shop_section
      s2 = create :shop_section
      s3 = create :shop_section
      s4 = create :shop_section, section: s1

      delete shiny_shop.section_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_shop.admin.sections.destroy.success' )
      expect( response.body ).to     have_css 'td', text: s1.internal_name
      expect( response.body ).not_to have_css 'td', text: s2.internal_name
      expect( response.body ).to     have_css 'td', text: s3.internal_name
    end

    it 'fails gracefully when attempting to delete a non-existent section' do
      delete shiny_shop.section_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_shop.products_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_shop.admin.products.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_shop.admin.sections.destroy.failure' )
    end
  end
end
