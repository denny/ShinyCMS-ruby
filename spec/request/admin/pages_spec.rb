require 'rails_helper'

RSpec.describe 'Admin: Pages', type: :request do
  describe 'GET /admin/pages' do
    it 'fetches the list of pages in the admin area' do
      create :page
      page = create :page, :hidden
      subpage = create :page_in_section
      create :page_in_section, :hidden
      create :page_in_subsection
      hidden_subpage = create :page_in_subsection, :hidden
      hidden_section = create :page_section, :hidden
      create :page, section: hidden_section

      get admin_pages_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.list_pages' ).titlecase
      expect( response.body ).to include I18n.t( 'admin.pages.top_level_pages' )
      expect( response.body ).to include page.name
      expect( response.body ).to include subpage.name
      expect( response.body ).to include subpage.section.name
      expect( response.body ).to include hidden_subpage.name
      expect( response.body ).to include hidden_section.name
    end
  end

  describe 'GET /admin/page/new' do
    it 'loads the form to add a new page' do
      get admin_page_new_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.new_page' ).titlecase
    end
  end

  describe 'POST /admin/page/new' do
    it 'fails when the form is submitted without all the details' do
      post admin_page_new_path, params: {
        'page[title]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.new_page' ).titlecase
      expect( response.body ).to have_css '#alerts', text: I18n.t( 'admin.pages.page_create_failed' )
    end

    it 'fails when the page slug collides with a controller namespace' do
      template = create :page_template

      post admin_page_new_path, params: {
        'page[name]': 'Test',
        'page[title]': 'Test',
        'page[slug]': 'user',
        'page[template_id]': template.id
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.new_page' ).titlecase
      expect( response.body ).to have_css '#alerts', text: I18n.t( 'admin.pages.page_create_failed' )
    end

    it 'adds a new page when the form is submitted' do
      template = create :page_template

      post admin_page_new_path, params: {
        'page[name]': 'Test',
        'page[template_id]': template.id
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_page_path( Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase
      expect( response.body ).to have_css '#notices', text: I18n.t( 'admin.pages.page_created' )
    end

    it 'adds a new page with elements from template' do
      template = create :page_template

      post admin_page_new_path, params: {
        'page[name]': 'Test',
        'page[title]': 'Test',
        'page[slug]': 'test',
        'page[template_id]': template.id
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_page_path( Page.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase
      expect( response.body ).to have_css '#notices', text: I18n.t( 'admin.pages.page_created' )
      expect( response.body ).to include template.elements.first.name
      expect( response.body ).to include template.elements.last.name
    end
  end

  describe 'GET /admin/page/:id' do
    it 'loads the form to edit an existing page' do
      page = create :page

      get admin_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase
    end
  end

  describe 'POST /admin/page/:id' do
    it 'fails to update the page when submitted with a blank name' do
      page = create :page

      post admin_page_path( page ), params: {
        'page[name]': ''
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase
      expect( response.body ).to have_css '#alerts', text: I18n.t( 'admin.pages.page_update_failed' )
    end

    it 'updates the page when the form is submitted' do
      page = create :page

      post admin_page_path( page ), params: {
        'page[name]': 'Updated by test'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_page_path( page )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase
      expect( response.body ).to have_css '#notices', text: I18n.t( 'admin.pages.page_updated' )
      expect( response.body ).to include 'Updated by test'
    end

    it 'recreates the slug if it is wiped before submitting an update' do
      page = create :page
      old_slug = page.slug

      post admin_page_path( page ), params: {
        'page[name]': 'Updated by test',
        'page[slug]': ''
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_page_path( page )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.pages.edit_page' ).titlecase
      expect( response.body ).to     have_css '#notices', text: I18n.t( 'admin.pages.page_updated' )
      expect( response.body ).to     include 'updated-by-test'
      expect( response.body ).not_to include old_slug
    end

    it 'shows the appropriate input type for each element type' do
      allow( PageElement ).to receive_message_chain(
        :select_filenames
      ).and_return( %w[ FILE.png image.jpeg image.gif ] )

      page = create :page_with_one_of_each_element_type

      get admin_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.edit_page' ).titlecase

      expect( response.body ).to match %r{<input [^>]*value="SHORT!"[^>]*>}
      expect( response.body ).to match %r{<textarea [^>]+>\nLONG!</textarea>}
      expect( response.body ).to match %r{<option [^>]+>FILE.png</option>}

      CKE_REGEX = %r{<textarea [^>]*id="(?<cke_id>page_elements_attributes_\d+_content)"[^>]*>\nHTML!</textarea>}.freeze
      matches = response.body.match CKE_REGEX
      expect( response.body ).to include "CKEDITOR.replace('#{matches[:cke_id]}'"
    end
  end

  describe 'DELETE /admin/page/delete/:id' do
    it 'deletes the specified page' do
      p1 = create :page
      p2 = create :page
      p3 = create :page

      delete admin_page_delete_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_pages_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.pages.list_pages' ).titlecase
      expect( response.body ).to     have_css '#notices', text: I18n.t( 'admin.pages.page_deleted' )
      expect( response.body ).to     include p1.name
      expect( response.body ).not_to include p2.name
      expect( response.body ).to     include p3.name
    end

    it 'fails gracefully when attempting to delete a non-existent page' do
      delete admin_page_delete_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.list_pages' ).titlecase
      expect( response.body ).to have_css '#alerts', text: I18n.t( 'admin.pages.page_delete_failed' )
    end
  end
end
