require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /pages' do
    it 'fetches the default page' do
      get '/pages'
      expect( response ).to have_http_status :ok
    end
  end
end
