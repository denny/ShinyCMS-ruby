require 'rails_helper'

RSpec.describe 'Admin: Page Sections', type: :request do
  describe 'GET /admin/pages/sections' do
    it 'redirects to the combined pages+sections list' do
      get admin_pages_sections_path

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'List pages'
    end
  end

  describe 'GET /admin/pages/section/new' do
    it 'loads the form to add a new section' do
      get admin_pages_section_new_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Add new section'
    end
  end

  describe 'POST /admin/pages/section/new' do
    it 'fails when the form is submitted without all the details' do
      post admin_pages_section_new_path, params: {
        'page_section[title]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'section_create_failed'
    end

    it 'adds a new section when the form is submitted' do
      post admin_pages_section_new_path, params: {
        'page_section[name]': 'Test',
        'page_section[title]': 'Test',
        'page_section[slug]': 'test'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit section'
    end
  end

  describe 'GET /admin/pages/section/:id' do
    it 'loads the form to edit an existing section' do
      section = create :page_section

      get admin_pages_section_path( section )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit section'
    end
  end

  describe 'POST /admin/pages/section/:id' do
    it 'fails to update the section when submitted without all the details' do
      section = create :page_section

      post admin_pages_section_path( section ), params: {
        'page_section[name]': nil
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'section_update_failed'
    end

    it 'updates the section when the form is submitted' do
      section = create :page_section

      post admin_pages_section_path( section ), params: {
        'page_section[name]': 'Updated by test'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Updated by test'
    end
  end
end
