require 'rails_helper'

RSpec.describe 'Admin: Site Settings', type: :request do
  before :each do
    admin = create :settings_admin
    sign_in admin
  end

  describe 'GET /admin/settings' do
    it 'fetches the site settings page in the admin area' do
      get settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
    end
  end

  describe 'POST /admin/setting' do
    it 'adds a new setting, with a string value' do
      post setting_path, params: {
        'setting[name]': 'New Setting Is New',
        'setting[value]': 'AND IMPROVED!'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.settings.create.success' )
      expect( response.body ).to include 'New Setting Is New'
    end

    it 'adds a new setting, with an empty string value' do
      post setting_path, params: {
        'setting[name]': 'New Setting Is Empty',
        'setting[value]': ''
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.settings.create.success' )
      expect( response.body ).to include 'New Setting Is Empty'
    end

    it 'adds a new setting, with an explicitly null value' do
      post setting_path, params: {
        'setting[name]': 'New Setting Is Null',
        'setting[value]': nil
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.settings.create.success' )
      expect( response.body ).to include 'New Setting Is Null'
    end

    it 'attempting to add a new setting with no name fails gracefully' do
      post setting_path, params: {
        'setting[value]': 'MADE OF FAIL!'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.settings.create.failure' )
    end
  end

  describe 'DELETE /admin/setting/delete/:id' do
    it 'deletes the specified setting' do
      s1 = create :setting
      s2 = create :setting, name: 'DO NOT WANT'
      s3 = create :setting

      delete delete_setting_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.settings.destroy.success' )
      expect( response.body ).to     include s1.name
      expect( response.body ).to     include s3.name
      expect( response.body ).not_to include s2.name
    end

    it 'fails gracefully when attempting to delete a non-existent setting' do
      delete delete_setting_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.settings.destroy.failure' )
    end
  end

  describe 'POST /admin/settings' do
    it 'updates any settings that were changed' do
      create :setting
      s2 = create :setting, value: 'Original value'
      create :setting

      put settings_path, params: {
        "settings[setting_value_#{s2.id}]": 'Updated value'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.settings.update.success' )
      expect( response.body ).not_to include 'Original value'
      expect( response.body ).to     include 'Updated value'
    end

    it "doesn't update settings if they weren't changed" do
      create :setting
      s2 = create :setting
      create :setting

      put settings_path, params: {
        "settings[setting_value_#{s2.id}]": s2.value
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.settings.update.failure' )
      expect( response.body ).to include s2.value
    end
  end
end
