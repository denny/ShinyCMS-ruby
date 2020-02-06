require 'rails_helper'

RSpec.describe 'Admin: Site Settings', type: :request do
  before :each do
    admin = create :settings_admin
    sign_in admin
  end

  describe 'GET /admin/settings' do
    it 'fetches the site settings page in the admin area' do
      s1 = create :setting, name: 'theme_name'
      create :setting_value, setting_id: s1.id

      get settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.settings.index.title' ).titlecase
    end
  end

  describe 'POST /admin/settings' do
    it 'updates any settings that were changed' do
      skip 'TODO: FIXME'
      s1 = create :setting, name: 'theme_name'
      s2 = create :setting, name: 'default_page'
      s3 = create :setting, name: 'default_section'
      create :setting_value, setting_id: s1.id
      create :setting_value, setting_id: s2.id, value: 'Original value'
      create :setting_value, setting_id: s3.id

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
      skip 'TODO: FIXME'
      s1 = create :setting, name: 'theme_name'
      s2 = create :setting, name: 'default_page'
      create :setting_value, setting_id: s1.id
      create :setting_value, setting_id: s2.id

      put settings_path, params: {
        "settings[setting_name_#{s2.id}]": s1.name
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
