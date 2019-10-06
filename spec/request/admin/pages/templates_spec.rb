require 'rails_helper'

RSpec.describe 'Admin: Page Templates', type: :request do
  describe 'GET /admin/pages/templates' do
    it 'fetches the list of templates in the admin area' do
      template = create :page_template
      get '/admin/pages/templates'
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'List templates'
      expect( response.body ).to include template.name
    end
  end

  describe 'GET /admin/pages/template/add' do
    it 'loads the form to add a new template' do
      get '/admin/pages/template/add'
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Add new template'
    end
  end

  describe 'POST /admin/pages/template/add' do
    it 'fails when the form is submitted without all the details' do
      post '/admin/pages/template/add', params: {
        'page_template[filename]': 'Test'
      }
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Failed to create new template'
    end
  end

  describe 'POST /admin/pages/template/add' do
    it 'adds a new template when the form is submitted' do
      post '/admin/pages/template/add', params: {
        'page_template[name]': 'Test',
        'page_template[filename]': 'Test'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Edit template'
    end
  end

  describe 'GET /admin/pages/template/:id' do
    it 'loads the form to edit an existing template' do
      template = create :page_template
      get "/admin/pages/template/#{template.id}"
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Add new template'
    end
  end

  describe 'POST /admin/pages/template/:id' do
    it 'fails to update the template when submitted without all the details' do
      template = create :page_template
      post "/admin/pages/template/#{template.id}", params: {
        'page_template[name]': nil
      }
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Failed to update template details'
    end
  end

  describe 'POST /admin/pages/template/:id' do
    it 'updates the template when the form is submitted' do
      template = create :page_template
      post "/admin/pages/template/#{template.id}", params: {
        'page_template[name]': 'Updated by test'
      }
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Updated by test'
    end
  end
end
