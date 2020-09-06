# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site usage of feature flags
RSpec.describe 'Feature Flags', type: :request do
  before :each do
    FeatureFlag.enable :user_login
    FeatureFlag.enable :profile_pages
  end

  describe 'GET /login' do
    it "succeeds with 'User Login = On'" do
      get new_user_session_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'user.log_in' )
    end

    it "fails with 'User Login = Off'" do
      create :top_level_page

      FeatureFlag.find_or_create_by!( name: 'user_login' )
                 .update!( enabled: false )

      get new_user_session_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '.alerts',
        text: I18n.t(
          'feature_flags.off_alert',
          feature_name: I18n.t( 'feature_flags.user_login' )
        )
      )
    end
  end

  describe 'GET /profile/{username}' do
    it 'fails for non-admin user with Profile Pages feature only enabled for admins' do
      create :top_level_page
      user = create :user
      sign_in user

      FeatureFlag.find_or_create_by!( name: 'profile_pages' )
                 .update!( enabled: false, enabled_for_admins: true )

      get shiny_profiles.profile_path( user.username )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '.alerts',
        text: I18n.t(
          'feature_flags.off_alert',
          feature_name: I18n.t( 'feature_flags.profile_pages' )
        )
      )
    end

    it 'succeeds for admin user with Profile Pages feature only enabled for admins' do
      user = create :admin_user
      sign_in user

      FeatureFlag.find_or_create_by!( name: 'profile_pages' )
                 .update!( enabled: false, enabled_for_admins: true )

      get shiny_profiles.profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end
end
