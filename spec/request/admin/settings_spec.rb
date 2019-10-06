require 'rails_helper'

RSpec.describe 'Admin: Site Settings', type: :request do
  describe 'GET /admin/settings' do
    it 'fetches the site settings page in the admin area' do
      get '/admin/settings'
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
    end
  end

  describe 'POST /admin/settings/create' do
    it 'adds a new setting' do
      post '/admin/setting/create', params: {
        'setting[name]': 'New Setting Is New',
        'setting[value]': 'AND IMPROVED!'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
    end
  end

  describe 'POST /admin/settings' do
    it 'updates any settings that were changed' do
      create :setting, name: 'test_setting_one'
      s2 = create :setting, name: 'test_setting_two'
      create :setting, name: 'test_setting_three'
      post '/admin/settings', params: {
        "shinycms_setting_#{s2.id}": 'Updated value'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
    end
  end
end
