require 'rails_helper'

RSpec.describe 'Admin: Page Templates', type: :request do
  describe 'GET /admin/pages/templates' do
    it 'fetches the list of templates in the admin area' do
      template = create :page_template

      get admin_pages_templates_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'List templates'
      expect( response.body ).to include template.name
    end
  end

  describe 'GET /admin/pages/template/new' do
    it 'loads the form to add a new template' do
      get admin_pages_template_new_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Add new template'
    end
  end

  describe 'POST /admin/pages/template/new' do
    it 'fails when the form is submitted without all the details' do
      post admin_pages_template_new_path, params: {
        'page_template[filename]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'template_create_failed'
    end

    it 'adds a new template when the form is submitted' do
      post admin_pages_template_new_path, params: {
        'page_template[name]': 'Test',
        'page_template[filename]': 'example'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit template'
    end
  end

  describe 'GET /admin/pages/template/:id' do
    it 'loads the form to edit an existing template' do
      template = create :page_template

      get admin_pages_template_path( template )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit template'
    end
  end

  describe 'POST /admin/pages/template/:id' do
    it 'fails to update the template when submitted without all the details' do
      template = create :page_template

      post admin_pages_template_path( template ), params: {
        'page_template[name]': nil
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t 'template_update_failed'
    end

    it 'updates the template when the form is submitted' do
      template = create :page_template_with_elements

      post admin_pages_template_path( template ), params: {
        'page_template[name]': 'Updated by test',
        'elements[element_1_name]': 'updated_element_name',
        'elements[element_1_type]': 'HTML'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Updated by test'
    end
  end
end
