# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for site setting features on main site
RSpec.describe ShinyCMS::SiteSettingsController, type: :request do
  let( :test_user ) { ShinyCMS::User.first }

  let( :setting ) do
    theme = ShinyCMS::Setting.find_by( name: 'theme_name' )
    theme.update!( level: 'user' )
    theme
  end

  let( :setting_value ) { create :setting_value, setting: setting, user: test_user }

  let( :initial_value ) { setting_value.value }

  before do
    user = create :user
    sign_in user

    initial_value
  end

  describe 'GET /site-settings' do
    it 'fetches the site settings page' do
      get shinycms.site_settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.site_settings.index.title' ).titlecase
    end
  end

  describe 'PUT /site-settings' do
    it 'updates any setting values that were changed' do
      new_value = Faker::Books::CultureSeries.unique.culture_ship

      put shinycms.site_settings_path, params: {
        settings: {
          "value_#{setting.id}": new_value
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'shinycms.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{setting.id}]", with: new_value
      expect( response.body ).not_to have_field "settings[value_#{setting.id}]", with: initial_value
    end

    it 'updates the value of an admin-only setting' do
      new_value = Faker::Books::CultureSeries.unique.culture_ship

      admin = create :admin_user
      sign_in admin

      setting.update! level: 'admin'
      setting_value.update! user: admin

      put shinycms.site_settings_path, params: {
        settings: {
          "value_#{setting.id}": new_value
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'shinycms.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{setting.id}]", with: new_value
      expect( response.body ).not_to have_field "settings[value_#{setting.id}]", with: initial_value
    end

    it "doesn't update settings if they weren't changed" do
      put shinycms.site_settings_path, params: {
        settings: {
          "value_#{setting.id}": initial_value
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.site_settings.index.title' ).titlecase
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.site_settings.update.unchanged' )
      expect( response.body ).to have_field "settings[value_#{setting.id}]", with: initial_value
    end

    it 'updates the value of a locked setting' do
      new_value = Faker::Books::CultureSeries.unique.culture_ship

      s1 = ShinyCMS::Setting.find_by( name: 'recaptcha_score_for_comments' )
      s1.values.create_or_find_by!( user: test_user, value: initial_value )

      put shinycms.site_settings_path, params: {
        settings: {
          "value_#{setting.id}": new_value
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'shinycms.site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{setting.id}]", with: new_value
      expect( response.body ).not_to have_field "settings[value_#{setting.id}]", with: initial_value
    end
  end
end
