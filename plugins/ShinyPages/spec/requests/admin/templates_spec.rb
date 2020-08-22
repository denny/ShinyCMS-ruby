# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin: Page Templates', type: :request do
  before :each do
    admin = create :page_template_admin
    sign_in admin
  end

  describe 'GET /admin/pages/templates' do
    it 'fetches the list of templates in the admin area' do
      template = create :page_template

      get shiny_pages.templates_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: template.name
    end
  end

  describe 'GET /admin/pages/template/new' do
    it 'loads the form to add a new template' do
      get shiny_pages.new_template_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.new.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/template/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_pages.templates_path, params: {
        'page_template[filename]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.templates.create.failure' )
    end

    it 'adds a new template when the form is submitted' do
      post shiny_pages.templates_path, params: {
        'page_template[name]': 'Test',
        'page_template[filename]': 'an_example'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.templates.create.success' )
    end

    it 'adds the right number of elements to the new template' do
      post shiny_pages.templates_path, params: {
        'page_template[name]': 'Another Test',
        'page_template[filename]': 'an_example'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.templates.create.success' )
      expect( ShinyPages::TemplateElement.count ).to eq 4
    end
  end

  describe 'GET /admin/pages/template/:id' do
    it 'loads the form to edit an existing template' do
      template = create :page_template

      get shiny_pages.edit_template_path( template )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/template/:id' do
    it 'fails to update the template when submitted without all the details' do
      template = create :page_template

      put shiny_pages.template_path( template ), params: {
        'page_template[name]': nil
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.templates.update.failure' )
    end

    it 'updates the template when the form is submitted' do
      template = create :page_template
      e_id = ShinyPages::TemplateElement.last.id

      put shiny_pages.template_path( template ), params: {
        'page_template[name]': 'Updated by test',
        "elements[element_#{e_id}_name]": 'updated_element_name',
        "elements[element_#{e_id}_content]": 'Default content',
        "elements[element_#{e_id}_type]": 'HTML'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.templates.update.success' )
      expect( response.body ).to include 'Updated by test'
    end
  end

  describe 'DELETE /admin/pages/template/delete/:id' do
    it 'deletes the specified templates' do
      t1 = create :page_template
      t2 = create :page_template
      create :page_template

      delete shiny_pages.template_path( t2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_pages.templates_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_pages.admin.templates.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_pages.admin.templates.destroy.success' )
      expect( response.body ).to     have_css 'td', text: t1.name
      expect( response.body ).not_to have_css 'td', text: t2.name
    end

    it 'fails gracefully when attempting to delete a non-existent template' do
      delete shiny_pages.template_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.templates_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_pages.admin.templates.destroy.failure' )
    end
  end
end
