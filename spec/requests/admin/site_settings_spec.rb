require 'rails_helper'

RSpec.describe 'Admin: Site Settings', type: :request do
  before :each do
    admin = create :settings_admin
    sign_in admin
  end

  describe 'GET /admin/site-settings' do
    it 'fetches the site settings page in the admin area' do
      Setting.set( :theme_name ).to 'thematic'

      get admin_site_settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/site-settings' do
    it 'updates any setting levels that were changed' do
      s1 = Setting.set( :theme_name ).to 'thematic'

      put admin_site_settings_path, params: {
        "settings[level_#{s1.id}]": 'user',
        "settings[value_#{s1.id}]": 'thematic'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[level_#{s1.id}]",
                                                id: "settings_level_#{s1.id}_user",
                                                checked: true
      expect( response.body ).not_to have_field "settings[level_#{s1.id}]",
                                                id: "settings_level_#{s1.id}_site",
                                                checked: true
    end

    it 'updates any setting values that were changed' do
      s1 = Setting.set( :theme_name ).to 'Original'

      put admin_site_settings_path, params: {
        "settings[level_#{s1.id}]": s1.level,
        "settings[value_#{s1.id}]": 'Updated'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.site_settings.update.success' )
      expect( response.body ).not_to include 'Original'
      expect( response.body ).to     include 'Updated'
    end

    it "doesn't update settings if they weren't changed" do
      s1 = Setting.set( :theme_name ).to 'Unchanging'

      put admin_site_settings_path, params: {
        "settings[level_#{s1.id}]": s1.level,
        "settings[value_#{s1.id}]": 'Unchanging'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-info', text: I18n.t( 'admin.site_settings.update.unchanged' )
      expect( response.body ).to have_field "settings[value_#{s1.id}]", with: 'Unchanging'
    end

    it "won't update the level of a locked setting" do
      s1 = Setting.set( :admin_ip_list ).to '127.0.0.1, 1.2.3.4'

      put admin_site_settings_path, params: {
        "settings[level_#{s1.id}]": 'user',
        "settings[value_#{s1.id}]": '127.0.0.1, 1.2.3.4'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'admin.site_settings.update.failure' )
      expect( response.body ).to     have_field "settings[level_#{s1.id}]",
                                                id: "settings_level_#{s1.id}_site",
                                                disabled: true,
                                                checked: true
      expect( response.body ).not_to have_field "settings[level_#{s1.id}]",
                                                id: "settings_level_#{s1.id}_user",
                                                disabled: true,
                                                checked: true
    end

    it 'will update the value of a locked setting' do
      s1 = Setting.set( :admin_ip_list ).to '127.0.0.1, 1.2.3.4'

      put admin_site_settings_path, params: {
        "settings[level_#{s1.id}]": s1.level,
        "settings[value_#{s1.id}]": '127.0.0.1, 4.3.2.1'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{s1.id}]", with: '127.0.0.1, 4.3.2.1'
      expect( response.body ).not_to have_field "settings[value_#{s1.id}]", with: '127.0.0.1, 1.2.3.4'
    end
  end
end
