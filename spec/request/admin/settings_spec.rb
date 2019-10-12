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
    it 'adds a new setting, with a string value' do
      post '/admin/setting/create', params: {
        'setting[name]': 'New Setting Is New',
        'setting[value]': 'AND IMPROVED!'
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
      expect( response.body ).to include 'New Setting Is New'
    end
    it 'adds a new setting, with an empty string value' do
      post '/admin/setting/create', params: {
        'setting[name]': 'New Setting Is Empty',
        'setting[value]': ''
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
      expect( response.body ).to include 'New Setting Is Empty'
    end
    it 'adds a new setting, with an explicitly null value' do
      post '/admin/setting/create', params: {
        'setting[name]': 'New Setting Is Null',
        'setting[value]': nil
      }
      expect( response ).to have_http_status :found
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to include 'Site Settings'
      expect( response.body ).to include 'New Setting Is Null'
    end
  end

  describe 'DELETE /admin/setting/delete/:id' do
    it 'deletes the specified setting' do
      s1 = create :setting
      s2 = create :setting, name: 'DO NOT WANT'
      s3 = create :setting

      delete admin_setting_delete_path( s2.id )

      expect( response      ).to     have_http_status :found
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     include 'Site Settings'
      expect( response.body ).to     include I18n.t 'setting_deleted'
      expect( response.body ).to     include s1.name
      expect( response.body ).to     include s3.name
      expect( response.body ).not_to include s2.name
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
