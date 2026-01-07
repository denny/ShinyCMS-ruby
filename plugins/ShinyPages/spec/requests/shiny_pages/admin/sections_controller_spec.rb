# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for page section admin features
RSpec.describe ShinyPages::Admin::SectionsController, type: :request do
  before do
    admin = create :page_admin
    sign_in admin
  end

  describe 'GET /admin/pages/sections' do
    it 'redirects to the combined pages+sections list' do
      get shiny_pages.sections_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
    end
  end

  describe 'GET /admin/pages/section/new' do
    it 'loads the form to add a new section' do
      get shiny_pages.new_section_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.new.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/section/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_pages.sections_path, params: {
        section: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.sections.create.failure' )
    end

    it 'fails if top-level section slug collides with a controller namespace' do
      post shiny_pages.sections_path, params: {
        section: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          slug:          'test'
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.sections.create.failure' )
    end

    it 'adds a new section when the form is submitted' do
      ship_name = Faker::Books::CultureSeries.unique.culture_ship

      post shiny_pages.sections_path, params: {
        section: {
          internal_name: ship_name,
          slug:          ship_name.parameterize
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_section_path( ShinyPages::Section.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.sections.create.success' )
    end
  end

  describe 'GET /admin/pages/section/:id' do
    it 'loads the form to edit an existing section' do
      section = create :page_section

      get shiny_pages.edit_section_path( section )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/section/:id' do
    it 'fails to update the section when submitted without all the details' do
      section = create :page_section

      put shiny_pages.section_path( section ), params: {
        section: {
          internal_name: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.sections.update.failure' )
    end

    it 'updates the section when the form is submitted' do
      section = create :page_section

      put shiny_pages.section_path( section ), params: {
        section: {
          internal_name: 'Updated by test'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_section_path( section )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.sections.update.success' )
      expect( response.body ).to have_field 'section[internal_name]', with: 'Updated by test'
    end

    it 'moves a top-level section inside another section' do
      section1 = create :page_section
      section2 = create :page_section

      put shiny_pages.section_path( section1 ), params: {
        section: {
          section_id: section2.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_section_path( section1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.sections.update.success' )
      expect( response.body ).to have_field 'section[section_id]', with: section2.id
    end
  end

  describe 'DELETE /admin/pages/section/delete/:id' do
    it 'deletes the specified section' do
      s1 = create :page_section
      s2 = create :page_section
      s3 = create :page_section

      delete shiny_pages.section_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_pages.admin.sections.destroy.success' )
      expect( response.body ).to     have_css 'td', text: s1.internal_name
      expect( response.body ).not_to have_css 'td', text: s2.internal_name
      expect( response.body ).to     have_css 'td', text: s3.internal_name
    end

    it 'fails gracefully when attempting to delete a non-existent section' do
      delete shiny_pages.section_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.sections.destroy.failure' )
    end
  end
end
