# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user authentication (login/logout) features on main site (powered by Devise)
RSpec.describe ShinyCMS::Users::SessionsController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :user_login
    ShinyCMS::FeatureFlag.disable :user_profiles

    create :top_level_page
  end

  let( :test_password ) { Faker::Internet.unique.password( min_length: 10 ) }

  describe 'GET /login' do
    it 'renders the user login page if user logins are enabled' do
      get shinycms.new_user_session_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'shinycms.user.log_in' )
    end

    it 'redirects to the site homepage if user logins are not enabled' do
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
      expect( response.body ).not_to have_button I18n.t( 'shinycms.user.log_in' )
    end

    it 'defaults to assuming that user logins are not enabled' do
      ShinyCMS::FeatureFlag.find_by( name: 'user_login' ).update!( name: 'test' )

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
      expect( response.body ).not_to have_button I18n.t( 'shinycms.user.log_in' )

      ShinyCMS::FeatureFlag.find_by( name: 'test' ).update!( name: 'user_login' )
    end
  end

  describe 'POST /login' do
    it 'logs the user in using their email address' do
      user = create :user, password: test_password

      post shinycms.user_session_path, params: {
        user: {
          login:    user.email,
          password: test_password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link I18n.t( 'shinycms.user.log_out' )
    end

    it 'logs the user in using their username' do
      user = create :user, password: test_password

      post shinycms.user_session_path, params: {
        user: {
          login:    user.username,
          password: test_password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link I18n.t( 'shinycms.user.log_out' )
    end

    it 'redirects back to the referring page after login, if it knows it' do
      user = create :user, password: test_password

      create :top_level_page
      page2 = create :page_in_section
      create :page_in_section

      get  page2.path
      post shinycms.user_session_path, params: {
        user: {
          login:    user.username,
          password: test_password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to page2.path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h1', text: page2.name
    end

    it 'fails a login attempt with incorrect password' do
      user = create :user, password: test_password

      post shinycms.user_session_path, params: {
        user: {
          login:    user.email,
          password: 'FAIL'
        }
      }

      expect( response      ).not_to have_http_status :found
      expect( response.body ).not_to have_link I18n.t( 'shinycms.user.log_out' )
      expect( response.body ).to     have_button I18n.t( 'shinycms.user.log_in' )
    end
  end
end
