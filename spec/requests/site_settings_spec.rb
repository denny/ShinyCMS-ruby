require 'rails_helper'

RSpec.describe 'Site Settings', type: :request do
  before :each do
    @user = create :user
    sign_in @user
  end

  describe 'GET /site-settings' do
    it 'fetches the site settings page' do
      s1 = create :setting, name: 'theme_name', level: 'user'
      create :setting_value, setting_id: s1.id, user_id: @user.id, value: 'One'

      get site_settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'site_settings.index.title' ).titlecase
    end
  end

  describe 'PUT /site-settings' do
    it 'updates any setting values that were changed' do
      s1 = create :setting, name: 'theme_name', level: 'user'
      create :setting_value, setting_id: s1.id, user_id: @user.id, value: 'One'

      put site_settings_path, params: {
        "settings[value_#{s1.id}]": 'Two'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'site_settings.update.success' )
      expect( response.body ).to     include 'Two'
      expect( response.body ).not_to include 'One'
    end

    it 'updates the value of an admin-only setting' do
      admin = create :admin_user
      sign_in admin
      s1 = create :setting, name: 'theme_name', level: 'admin'
      create :setting_value, setting_id: s1.id, user_id: admin.id, value: 'One'

      put site_settings_path, params: {
        "settings[value_#{s1.id}]": 'Two'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'site_settings.update.success' )
      expect( response.body ).to     include 'Two'
      expect( response.body ).not_to include 'One'
    end

    it "doesn't update settings if they weren't changed" do
      s1 = create :setting, name: 'theme_name', level: 'user'
      create :setting_value, setting_id: s1.id, user_id: @user.id, value: 'One'

      put site_settings_path, params: {
        "settings[value_#{s1.id}]": 'One'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to have_css '.notices', text: I18n.t( 'site_settings.update.unchanged' )
      expect( response.body ).to have_field "settings[value_#{s1.id}]", with: 'One'
    end

    it 'will update the value of a locked setting' do
      s1 = create :setting, name: 'theme_name', level: 'user', locked: true
      create :setting_value, setting_id: s1.id, user_id: @user.id, value: 'One'

      put site_settings_path, params: {
        "settings[value_#{s1.id}]": 'Two'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{s1.id}]", with: 'Two'
      expect( response.body ).not_to have_field "settings[value_#{s1.id}]", with: 'One'
    end
  end
end
