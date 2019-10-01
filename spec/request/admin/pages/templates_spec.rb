require 'rails_helper'

RSpec.describe 'Admin: Page Templates', type: :request do
  describe 'GET /admin/pages/templates' do
    it 'fetches the list of templates in the admin area' do
      get '/admin/pages/templates'
      expect( response ).to have_http_status :ok
    end
  end
end
