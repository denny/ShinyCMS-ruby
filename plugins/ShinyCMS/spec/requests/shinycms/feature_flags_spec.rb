# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site usage of feature flags
RSpec.describe 'Feature Flags (main site)', type: :request do
  describe 'GET /login' do
    before do
      ShinyCMS::FeatureFlag.enable :user_profiles
    end

    context 'when the user_logins feature flag is on' do
      it 'loads the login page' do
        ShinyCMS::FeatureFlag.enable :user_login

        get shinycms.new_user_session_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include I18n.t( 'shinycms.user.log_in' )
      end
    end

    context 'when the user_logins feature flag is off' do
      it 'redirects to the homepage' do
        create :top_level_page

        ShinyCMS::FeatureFlag.disable :user_login

        get shinycms.new_user_session_path

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to main_app.root_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_css(
          '.alerts',
          text: I18n.t(
            'shinycms.feature_flags.off_alert',
            feature_name: I18n.t( 'shinycms.feature_flags.user_login' )
          )
        )
      end
    end
  end

  describe 'GET /profile/{username}' do
    before do
      ShinyCMS::FeatureFlag.find_by!( name: 'user_profiles' ).update!(
        enabled:               false,
        enabled_for_logged_in: false,
        enabled_for_admins:    true
      )
    end

    context 'with Profile Pages feature only enabled for admins' do
      it 'succeeds for an admin user' do
        user = create :admin_user
        sign_in user

        get shiny_profiles.profile_path( user.username )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title user.profile.name
      end

      it 'fails for a non-admin user' do
        create :top_level_page

        user = create :user
        sign_in user

        get shiny_profiles.profile_path( user.username )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to main_app.root_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_css(
          '.alerts',
          text: I18n.t(
            'shinycms.feature_flags.off_alert',
            feature_name: I18n.t( 'shinycms.feature_flags.user_profiles' )
          )
        )
      end
    end
  end
end
