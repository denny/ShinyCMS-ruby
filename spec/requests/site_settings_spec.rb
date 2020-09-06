# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for site setting features on main site
RSpec.describe SiteSettingsController, type: :request do
  before :each do
    @user = create :user
    sign_in @user

    @setting = Setting.find_by( name: 'theme_name' )
    @setting.update!( level: 'user' )
    @value = @setting.values.create_or_find_by!( value: 'One', user_id: @user.id )
  end

  describe 'GET /site-settings' do
    it 'fetches the site settings page' do
      get site_settings_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'site_settings.index.title' ).titlecase
    end
  end

  describe 'PUT /site-settings' do
    it 'updates any setting values that were changed' do
      put site_settings_path, params: {
        "settings[value_#{@setting.id}]": 'Two'
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

      @setting.update! level: 'admin'
      @value.update! user: admin

      put site_settings_path, params: {
        "settings[value_#{@setting.id}]": 'Two'
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
      put site_settings_path, params: {
        "settings[value_#{@setting.id}]": 'One'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to have_css '.notices', text: I18n.t( 'site_settings.update.unchanged' )
      expect( response.body ).to have_field "settings[value_#{@setting.id}]", with: 'One'
    end

    it 'will update the value of a locked setting' do
      s1 = Setting.find_by( name: 'recaptcha_comment_score' )
      s1.values.create_or_find_by!( user_id: @user.id, value: 'One' )

      put site_settings_path, params: {
        "settings[value_#{@setting.id}]": 'Two'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to site_settings_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'site_settings.index.title' ).titlecase
      expect( response.body ).to     have_css '.notices', text: I18n.t( 'site_settings.update.success' )
      expect( response.body ).to     have_field "settings[value_#{@setting.id}]", with: 'Two'
      expect( response.body ).not_to have_field "settings[value_#{@setting.id}]", with: 'One'
    end
  end
end
