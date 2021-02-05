# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user authentication (login/logout) features on main site (powered by Devise)
RSpec.describe Users::SessionsController, type: :request do
  before do
    FeatureFlag.enable :user_login
    FeatureFlag.disable :user_profiles

    @page = create :top_level_page
  end

  describe 'GET /login' do
    it 'renders the user login page if user logins are enabled' do
      get new_user_session_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.log_in' )
    end

    it 'redirects to the site homepage if user logins are not enabled' do
      FeatureFlag.disable :user_login

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
      expect( response.body ).not_to have_button I18n.t( 'user.log_in' )
    end

    it 'defaults to assuming that user logins are not enabled' do
      FeatureFlag.find_by( name: 'user_login' ).update!( name: 'test' )

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
      expect( response.body ).not_to have_button I18n.t( 'user.log_in' )

      FeatureFlag.find_by( name: 'test' ).update!( name: 'user_login' )
    end
  end

  describe 'POST /login' do
    it 'logs the user in using their email address' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        user: {
          login:    user.email,
          password: password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link I18n.t( 'user.log_out' )
    end

    it 'logs the user in using their username' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        user: {
          login:    user.username,
          password: password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link I18n.t( 'user.log_out' )
    end

    it 'redirects back to the referring page after login, if it knows it' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      different_page = create :top_level_page
      should_go_here = "http://www.example.com/#{different_page.slug}"

      post user_session_path,
           params:  {
             user: {
               login:    user.username,
               password: password
             }
           },
           headers: {
             HTTP_REFERER: should_go_here
           }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to should_go_here
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h1', text: different_page.name
    end
  end
end
