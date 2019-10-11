require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  describe 'GET /admin' do
    it 'redirects to the page admin area' do
      get '/admin'
      expect( response ).to have_http_status :found
    end
    it 'still works with an IP whitelist set' do
      Setting.find_or_create_by!( name: I18n.t( 'admin_ip_whitelist' ) )
             .update!( value: '127.0.0.1' )
      get '/admin'
      expect( response ).to have_http_status :found
    end
    it 'fails with a blocking IP whitelist set' do
      Setting.find_or_create_by!( name: I18n.t( 'admin_ip_whitelist' ) )
             .update!( value: '10.10.10.10' )
      get '/admin'
      expect( response ).to have_http_status :found
      expect( response ).to redirect_to '/'
      follow_redirect!
      expect( response ).to have_http_status :ok
    end
  end
end
