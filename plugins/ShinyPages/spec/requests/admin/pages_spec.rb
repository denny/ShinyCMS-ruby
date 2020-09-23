# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin: Pages', type: :request do
  before :each do
    admin = create :page_admin
    sign_in admin
  end

  describe 'GET /admin/pages' do
    it 'fetches the list of pages in the admin area' do
      create :top_level_page
      page = create :page, :hidden
      subpage = create :page_in_section
      create :page_in_section, :hidden
      create :page_in_subsection
      hidden_subpage = create :page_in_subsection, :hidden
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
          public_name: 'Test'
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.pages.create.failure' )
    end

    it 'fails when the page slug collides with a controller namespace' do
      template = create :page_template

      post shiny_pages.pages_path, params: {
        page: {
          internal_name: 'Test',
          slug: 'account',
          template_id: template.id
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
          internal_name: 'Test',
          template_id: template.id
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
          internal_name: 'Test',
          template_id: template.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( ShinyPages::Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.create.success' )
      expect( response.body ).to include template.elements.first.name
      expect( response.body ).to include template.elements.last.name
    end
  end

  describe 'GET /admin/page/:id' do
    it 'loads the form to edit an existing page' do
      page = create :top_level_page

      get shiny_pages.edit_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
    end

    it 'shows the appropriate input type for each element type' do
      page = create :page_with_one_of_each_element_type

      get shiny_pages.edit_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase

      expect( response.body ).to have_field 'page[elements_attributes][4][content]',  type: 'text',     with: 'SHORT!'
      expect( response.body ).to have_field 'page[elements_attributes][5][content]',  type: 'textarea', with: 'LONG!'
      expect( response.body ).to have_field 'page[elements_attributes][6][content]',  type: 'select',
                                                                                      with: 'ShinyCMS-logo.png'
      expect( response.body ).to have_field 'page[elements_attributes][7][content]',  type: 'textarea', with: 'HTML!'
      cke_regex = %r{<textarea [^>]*id="(?<cke_id>page_elements_attributes_\d+_content)"[^>]*>\nHTML!</textarea>}.freeze
      matches = response.body.match cke_regex
      expect( response.body ).to include "CKEDITOR.replace('#{matches[:cke_id]}'"
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
          slug: ''
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

    it 'fails gracefully when attempting to delete a non-existent page' do
      delete shiny_pages.page_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.pages.destroy.failure' )
    end
  end
end
