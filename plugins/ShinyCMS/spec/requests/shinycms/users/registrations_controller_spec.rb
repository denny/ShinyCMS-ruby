# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user account registration/update features on main site (powered by Devise)
RSpec.describe ShinyCMS::Users::RegistrationsController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :user_login
    ShinyCMS::FeatureFlag.disable :user_profiles
  end

  let( :test_username ) { Faker::Internet.unique.username( specifier:   5 ) }
  let( :test_password ) { Faker::Internet.unique.password( min_length: 10 ) }

  let( :test_email ) { Faker::Internet.unique.email( name: test_username ) }

  describe 'GET /account/register' do
    before do
      ShinyCMS::FeatureFlag.enable :user_registration
      ShinyCMS::FeatureFlag.enable :recaptcha_for_registrations
    end

    it 'redirects to the site homepage if user registrations are not enabled' do
      create :top_level_page

      ShinyCMS::FeatureFlag.disable :user_registration

      get shinycms.new_user_registration_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '.alerts',
        text: I18n.t(
          'shinycms.feature_flags.off_alert',
          feature_name: I18n.t( 'shinycms.feature_flags.user_registration' )
        )
      )
      expect( response.body ).not_to have_button I18n.t( 'shinycms.user.register' )
    end

    it 'renders the user registration page if user registrations are enabled' do
      get shinycms.new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'shinycms.user.register' )
    end

    it 'includes the V3 reCAPTCHA code if a V3 key was set' do
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_v3_site_key ).and_return( 'A_KEY' )

      get shinycms.new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'shinycms.user.register' )
      # TODO: look for V3 html
    end

    it 'includes the V2 reCAPTCHA code if only a V2 key was set' do
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_v2_site_key ).and_return( 'A_KEY' )

      get shinycms.new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'shinycms.user.register' )
      # TODO: look for V2 html
    end

    it 'includes the checkbox reCAPTCHA code if only that key is set' do
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_checkbox_site_key ).and_return( 'A_KEY' )

      get shinycms.new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'shinycms.user.register' )
      # TODO: look for checkbox html
    end
  end

  describe 'POST /account/register' do
    before do
      ShinyCMS::FeatureFlag.enable :user_registration
    end

    it 'creates a new user, checking V3 reCAPTCHA if a V3 key is set' do
      create :top_level_page

      allow( described_class )
        .to receive( :recaptcha_v3_secret_key ).and_return( 'A_KEY' )
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_v3_site_key ).and_return( 'A_KEY' )

      post shinycms.user_registration_path, params: {
        user: {
          username: test_username,
          password: test_password,
          email:    test_email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include(
        'a confirmation link has been sent to your email address'
      )
    end

    it 'creates a new user, checking V2 invisible reCAPTCHA if no V3 key present' do
      create :top_level_page

      allow( described_class )
        .to receive( :recaptcha_v2_secret_key ).and_return( 'A_KEY' )
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_v2_site_key ).and_return( 'A_KEY' )

      post shinycms.user_registration_path, params: {
        user: {
          username: test_username,
          password: test_password,
          email:    test_email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include(
        'a confirmation link has been sent to your email address'
      )
    end

    it 'falls back to checkbox reCAPTCHA if invisible reCAPTCHA fails' do
      create :top_level_page

      allow_any_instance_of( described_class )
        .to receive( :recaptcha_checkbox_site_key ).and_return( 'A_KEY' )
      allow_any_instance_of( described_class )
        .to receive( :recaptcha_v3_site_key ).and_return( 'A_KEY' )

      post shinycms.user_registration_path, params: {
        user: {
          username: test_username,
          password: test_password,
          email:    test_email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.new_user_registration_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'textarea.g-recaptcha-response'

      allow( described_class )
        .to receive( :recaptcha_checkbox_secret_key ).and_return( 'A_KEY' )

      post shinycms.user_registration_path, params: {
        user: {
          username: test_username,
          password: test_password,
          email:    test_email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include(
        'a confirmation link has been sent to your email address'
      )
    end
  end

  describe 'GET /account/edit' do
    it 'loads the user edit page' do
      user = create :user
      sign_in user

      get shinycms.edit_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit User'
    end
  end

  describe 'PUT /account/update' do
    it 'updates the user when you submit the edit form' do
      user = create :user, password: test_password
      sign_in user

      new_name = Faker::Internet.unique.username

      put shinycms.user_registration_path, params: {
        user: {
          username:         new_name,
          current_password: test_password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.edit_user_registration_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'devise.registrations.updated' )
      expect( response.body ).to have_css 'a', text: new_name
    end
  end
end
