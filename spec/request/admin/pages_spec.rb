require 'rails_helper'

RSpec.describe 'Admin: Pages', type: :request do
  describe 'GET /admin/pages' do
    it 'fetches the list of pages in the admin area' do
      get '/admin/pages'
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'List pages'
    end
  end

  describe 'GET /admin/page/add' do
    it 'loads the form to add a new page' do
      get '/admin/page/add'
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Add new page'
    end
  end

  describe 'POST /admin/page/add' do
    it 'adds a new page when the form is submitted' do
      template = create :page_template
      post '/admin/page/add', params: {
        'page[name]': 'Test',
        'page[title]': 'Test',
        'page[slug]': 'test',
        'page[template_id]': template.id
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Edit page'
    end
  end
end
