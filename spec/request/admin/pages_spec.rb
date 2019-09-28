require 'rails_helper'

RSpec.describe 'Admin: Pages', type: :request do
  describe 'GET /admin/pages' do
    it 'fetches the list of pages in the admin area' do
      get '/admin/pages'
      expect( response ).to have_http_status :ok
    end
  end
end
