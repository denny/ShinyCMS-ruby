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
      expect( response.body ).to include 'List pages'
      expect( response.body ).to include 'Top-level pages'
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
      expect( response.body ).to include 'Add new page'
    end
  end

  describe 'POST /admin/page/new' do
    it 'fails when the form is submitted without all the details' do
      post admin_page_new_path, params: {
        'page[title]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'page_create_failed'
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
      expect( response.body ).to include I18n.t 'page_create_failed'
    end

    it 'adds a new page when the form is submitted' do
      template = create :page_template

      post admin_page_new_path, params: {
        'page[name]': 'Test',
        'page[template_id]': template.id
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit page'
    end

    it 'adds a new page with elements from template' do
      template = create :page_template_with_elements

      post admin_page_new_path, params: {
        'page[name]': 'Test',
        'page[title]': 'Test',
        'page[slug]': 'test',
        'page[template_id]': template.id
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit page'
      expect( response.body ).to include template.elements.first.name
      expect( response.body ).to include template.elements.last.name
    end
  end

  describe 'GET /admin/page/:id' do
    it 'loads the form to edit an existing page' do
      page = create :page

      get admin_page_path( page )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit page'
    end
  end

  describe 'POST /admin/page/:id' do
    it 'fails to update the page when submitted with a blank name' do
      page = create :page

      post admin_page_path( page ), params: {
        'page[name]': ''
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'page_update_failed'
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
      expect( response.body ).to     include 'updated-by-test'
      expect( response.body ).not_to include old_slug
    end
  end
end
