# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the site settings features in the admin area
RSpec.describe ShinyCMS::Admin::SiteSettingsController, type: :request do
  before do
    admin = create :settings_admin
    sign_in admin
  end

  describe 'GET /admin/site-settings' do
    it 'fetches the site settings page in the admin area' do
      ShinyCMS::Setting.set( :theme_name, to: 'thematic' )

      get shinycms.admin_site_settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/site-settings' do
    it 'updates any setting levels that were changed' do
      s1 = ShinyCMS::Setting.set( :theme_name, to: 'thematic' )

      put shinycms.admin_site_settings_path, params: {
        settings: {
          "level_#{s1.id}": 'user',
          "value_#{s1.id}": 'thematic'
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[level_#{s1.id}]",
                                                id:      "settings_level_#{s1.id}_user",
                                                checked: true
      expect( response.body ).not_to have_field "settings[level_#{s1.id}]",
                                                id:      "settings_level_#{s1.id}_site",
                                                checked: true
    end

    it 'updates any setting values that were changed' do
      s1 = ShinyCMS::Setting.set( :theme_name, to: 'Original' )

      put shinycms.admin_site_settings_path, params: {
        settings: {
          "level_#{s1.id}": s1.level,
          "value_#{s1.id}": 'Updated'
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.site_settings.update.success' )
      expect( response.body ).not_to include 'Original'
      expect( response.body ).to     include 'Updated'
    end

    it "doesn't update settings if they weren't changed" do
      s1 = ShinyCMS::Setting.set( :theme_name, to: 'Unchanging' )

      put shinycms.admin_site_settings_path, params: {
        settings: {
          "level_#{s1.id}": s1.level,
          "value_#{s1.id}": 'Unchanging'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.admin_site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-info', text: I18n.t( 'shinycms.admin.site_settings.update.unchanged' )
      expect( response.body ).to have_field "settings[value_#{s1.id}]", with: 'Unchanging'
    end

    it "doesn't update the level of a locked setting" do
      s1 = ShinyCMS::Setting.set( :allowed_ips, to: '127.0.0.1, 1.2.3.4' )

      put shinycms.admin_site_settings_path, params: {
        settings: {
          "level_#{s1.id}": 'user',
          "value_#{s1.id}": '127.0.0.1, 1.2.3.4'
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'shinycms.admin.site_settings.update.failure' )
      expect( response.body ).to     have_field "settings[level_#{s1.id}]",
                                                id:       "settings_level_#{s1.id}_site",
                                                disabled: true,
                                                checked:  true
      expect( response.body ).not_to have_field "settings[level_#{s1.id}]",
                                                id:       "settings_level_#{s1.id}_user",
                                                disabled: true,
                                                checked:  true
    end

    it 'updates the value of a locked setting' do
      s1 = ShinyCMS::Setting.set( :allowed_ips, to: '127.0.0.1, 1.2.3.4' )

      put shinycms.admin_site_settings_path, params: {
        settings: {
          "level_#{s1.id}": s1.level,
          "value_#{s1.id}": '127.0.0.1, 4.3.2.1'
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.admin_site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{s1.id}]", with: '127.0.0.1, 4.3.2.1'
      expect( response.body ).not_to have_field "settings[value_#{s1.id}]", with: '127.0.0.1, 1.2.3.4'
    end
  end
end
