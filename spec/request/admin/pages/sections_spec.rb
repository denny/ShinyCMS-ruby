require 'rails_helper'

RSpec.describe 'Admin: Page Sections', type: :request do
  describe 'GET /admin/pages/sections' do
    it 'fetches the list of sections in the admin area' do
      get '/admin/pages/sections'
      expect( response ).to have_http_status :ok
    end
  end
end
