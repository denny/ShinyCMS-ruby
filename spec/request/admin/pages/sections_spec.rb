require 'rails_helper'

RSpec.describe 'Admin: Page Sections', type: :request do
  describe 'GET /admin/pages/sections' do
    it 'fetches the list of sections in the admin area' do
      toppy = create :page_section
      subby = create :page_subsection
      get admin_pages_sections_path
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'List sections'
      expect( response.body ).to include toppy.name
      expect( response.body ).to include subby.name
      # expect( response.body ).to include 'Hidden top-level sections'  # FIXME
    end
  end

  describe 'GET /admin/pages/section/new' do
    it 'loads the form to add a new section' do
      get new_admin_pages_section_path
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Add new section'
    end
  end

  describe 'POST /admin/pages/section' do
    it 'fails when the form is submitted without all the details' do
      post '/admin/pages/section', params: {
        'page_section[title]': 'Test'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Failed to create new section'
    end
    it 'adds a new section when the form is submitted' do
      post '/admin/pages/section', params: {
        'page_section[name]': 'Test',
        'page_section[title]': 'Test',
        'page_section[slug]': 'test'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Edit section'
    end
  end

  describe 'GET /admin/pages/section/:id/edit' do
    it 'loads the form to edit an existing section' do
      section = create :page_section
      get edit_admin_pages_section_path( section )
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Edit section'
    end
  end

  describe 'PUT /admin/pages/section/:id' do
    it 'fails to update the section when submitted without all the details' do
      section = create :page_section
      put admin_pages_section_path( section ), params: {
        'page_section[name]': nil
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Failed to update section details'
    end
    it 'updates the section when the form is submitted' do
      section = create :page_section
      put admin_pages_section_path( section ), params: {
        'page_section[name]': 'Updated by test'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Updated by test'
    end
  end
end
