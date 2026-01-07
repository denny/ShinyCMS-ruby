# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for page admin features
RSpec.describe ShinyPages::Admin::PagesController, type: :request do
  before do
    admin = create :page_admin
    sign_in admin
  end

  describe 'GET /admin/pages' do
    it 'fetches the list of pages in the admin area' do
      create :top_level_page
      page = create :page, :hidden
      subpage = create :page_in_section
      create :page_in_section, :hidden
      create :page_in_nested_section
      hidden_subpage = create :page_in_nested_section, :hidden
      hidden_section = create :page_section, :hidden
      create :page, section: hidden_section

      get shiny_pages.pages_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase

      expect( response.body ).to have_css 'td', text: page.internal_name
      expect( response.body ).to have_css 'td', text: subpage.internal_name
      expect( response.body ).to have_css 'td', text: subpage.section.internal_name
      expect( response.body ).to have_css 'td', text: hidden_subpage.internal_name
      expect( response.body ).to have_css 'td', text: hidden_section.internal_name
    end
  end

  describe 'GET /admin/page/new' do
    it 'loads the form to add a new page' do
      get shiny_pages.new_page_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.new.title' ).titlecase
    end
  end

  describe 'POST /admin/page/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_pages.pages_path, params: {
        page: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.pages.create.failure' )
    end

    it 'fails if the page slug collides with a controller namespace' do
      template = create :page_template

      post shiny_pages.pages_path, params: {
        page: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          slug:          'test',
          template_id:   template.id
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.pages.create.failure' )
    end

    it 'adds a new page when the form is submitted' do
      template = create :page_template

      post shiny_pages.pages_path, params: {
        page: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id:   template.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( ShinyPages::Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.create.success' )
    end

    it 'adds a new page with elements from template' do
      template = create :page_template

      post shiny_pages.pages_path, params: {
        page: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id:   template.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( ShinyPages::Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.create.success' )
      expect( response.body ).to have_css 'label', text:  template.elements.first.name.humanize
      expect( response.body ).to have_css 'label', text: template.elements.last.name.humanize
    end
  end

  describe 'GET /admin/page/:id' do
    it 'loads the form to edit an existing page' do
      page = create :top_level_page, :with_content

      get shiny_pages.edit_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
    end

    it 'shows the appropriate input type for each element type' do
      page = create :page_with_element_type_content

      get shiny_pages.edit_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase

      expect( response.body ).to have_field 'page[elements_attributes][0][image]',   type: 'file'
      expect( response.body ).to have_field 'page[elements_attributes][1][content]', type: 'text',     with: 'SHORT!'
      expect( response.body ).to have_field 'page[elements_attributes][2][content]', type: 'textarea', with: 'LONG!'
      expect( response.body ).to have_field 'page[elements_attributes][3][content]', type: 'hidden', with: 'HTML!'
      expect( response.body ).to have_css   'trix-editor#page_elements_attributes_3_content'
    end
  end

  describe 'POST /admin/page/:id' do
    it 'fails to update the page when submitted with a blank name' do
      page = create :top_level_page

      put shiny_pages.page_path( page ), params: {
        page: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.pages.update.failure' )
    end

    it 'updates the page when the form is submitted' do
      page = create :top_level_page

      put shiny_pages.page_path( page ), params: {
        page: {
          internal_name: 'Updated by test'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( page )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.update.success' )
      expect( response.body ).to have_field 'page_internal_name', with: 'Updated by test'
    end

    it 'recreates the slug if it is wiped before submitting an update' do
      page = create :top_level_page
      old_slug = page.slug

      put shiny_pages.page_path( page ), params: {
        page: {
          internal_name: 'Updated by test',
          slug:          ''
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_pages.edit_page_path( page )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.update.success' )
      expect( response.body ).to     have_field 'page_slug', with: 'updated-by-test'
      expect( response.body ).not_to have_field 'page_slug', with: old_slug
    end

    it 'updates the element order' do
      template_admin = create :page_template_admin
      sign_in template_admin

      page = create :top_level_page
      last_element = page.elements.last

      # Put the last element first
      ids = page.elements.ids
      last_id = ids.pop
      ids.unshift last_id

      query_string = ''
      ids.each do |id|
        query_string += "sorted[]=#{id}&"
      end

      expect( last_element.position ).to eq ids.size

      put shiny_pages.page_path( page ), params: {
        page:       {
          internal_name: page.internal_name
        },
        sort_order: query_string
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.update.success' )

      expect( last_element.reload.position ).to eq 1
    end
  end

  describe 'DELETE /admin/page/delete/:id' do
    it 'deletes the specified page' do
      p1 = create :top_level_page
      p2 = create :top_level_page
      p3 = create :top_level_page

      delete shiny_pages.page_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_pages.admin.pages.destroy.success' )
      expect( response.body ).to     have_css 'td', text: p1.internal_name
      expect( response.body ).not_to have_css 'td', text: p2.internal_name
      expect( response.body ).to     have_css 'td', text: p3.internal_name
    end
  end

  describe 'PUT /admin/pages/sort' do
    it 'sorts the pages and sections as requested' do
      s1 = create :page_section, position: 1
      p2 = create :page, section: s1, position: 2
      p3 = create :top_level_page, position: 3
      s4 = create :page_section, position: 4
      p5 = create :top_level_page, position: 5

      put shiny_pages.sort_pages_path, params: {
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
