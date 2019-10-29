require 'rails_helper'

RSpec.describe 'Admin: Page Templates', type: :request do
  describe 'GET /admin/pages/templates' do
    it 'fetches the list of templates in the admin area' do
      template = create :page_template

      get admin_pages_templates_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'admin.pages.list_templates' ).titlecase
      expect( response.body ).to include template.name
    end
  end

  describe 'GET /admin/pages/template/new' do
    it 'loads the form to add a new template' do
      get admin_pages_template_new_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'admin.pages.new_template' ).titlecase
    end
  end

  describe 'POST /admin/pages/template/new' do
    it 'fails when the form is submitted without all the details' do
      post admin_pages_template_new_path, params: {
        'page_template[filename]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'admin.pages.new_template' ).titlecase
      expect( response.body ).to include I18n.t( 'admin.pages.template_create_failed' )
    end

    it 'adds a new template when the form is submitted' do
      post admin_pages_template_new_path, params: {
        'page_template[name]': 'Test',
        'page_template[filename]': 'example'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'admin.pages.edit_template' ).titlecase
      expect( response.body ).to include I18n.t( 'admin.pages.template_created' )
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
      expect( response.body ).to include I18n.t( 'admin.pages.edit_template' ).titlecase
      expect( response.body ).to include I18n.t( 'admin.pages.template_update_failed' )
    end

    it 'updates the template when the form is submitted' do
      template = create :page_template_with_elements
      e_id = PageTemplateElement.last.id

      post admin_pages_template_path( template ), params: {
        'page_template[name]': 'Updated by test',
        "elements[element_#{e_id}_name]": 'updated_element_name',
        "elements[element_#{e_id}_content]": 'Default content',
        "elements[element_#{e_id}_type]": 'HTML'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'admin.pages.edit_template' ).titlecase
      expect( response.body ).to include I18n.t( 'admin.pages.template_updated' )
      expect( response.body ).to include 'Updated by test'
    end
  end
end
