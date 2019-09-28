require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  describe 'GET /admin' do
    it 'redirects to the page admin area' do
      get '/admin'
      expect( response ).to have_http_status :found
    end
  end
end
