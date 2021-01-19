# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site controller
RSpec.describe 'ShinyProfiles::ProfilesController', type: :request do
  before do
    FeatureFlag.enable :user_login
    FeatureFlag.enable :user_profiles
  end

  describe 'GET /profiles' do
    it 'redirects to the site homepage until the profile gallery feature is built :)' do
      page = create :top_level_page

      get shiny_profiles.profiles_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.name
    end
  end

  describe 'GET /profile/:username' do
    it "renders the user's profile page" do
      user = create :user

      get shiny_profiles.profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title user.profile.name
    end

    it "renders the 404 page if the user doesn't exist", :production_error_responses do
      get shiny_profiles.profile_path( 'no.such.user' )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_title I18n.t( 'errors.not_found.title', resource_type: 'Page' )
    end
  end

  describe 'GET /profile/:username/edit' do
    it "renders the user's edit-profile page" do
      user = create :user
      sign_in user

      get shiny_profiles.edit_profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title user.profile.name
    end

    it "redirects if the profile doesn't belong to the current user" do
      create :top_level_page

      user1 = create :user
      user2 = create :user
      sign_in user2

      get shiny_profiles.edit_profile_path( user1.username )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_profiles.profiles.edit.not_authorized' )
    end
  end

  describe 'GET /profile' do
    it 'redirects to the login page if a user is not currently logged in' do
      get shiny_profiles.profile_redirect_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.new_user_session_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.log_in' )
    end

    it "redirects to the user's profile page when user is already logged in" do
      user = create :user
      sign_in user

      get shiny_profiles.profile_redirect_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_profiles.profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title user.profile.name
    end
  end

  describe 'POST /login' do
    it "redirects to the user's profile page if user profiles are enabled" do
      password = Faker::Books::CultureSeries.book
      user = create :user, password: password

      post user_session_path, params: {
        user: {
          login:    user.username,
          password: password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_profiles.profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title user.profile.name
    end

    it "redirects to the site root if user profiles aren't enabled" do
      password = Faker::Books::CultureSeries.book
      user = create :user, password: password

      FeatureFlag.disable :user_profiles
      page = create :top_level_page

      post user_session_path, params: {
        user: {
          login:    user.username,
          password: password
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h1', text: page.name
    end
  end

  describe 'PUT /profile/:username' do
    it "updates the user's profile details" do
      user = create :user
      sign_in user

      new_name = Faker::Books::CultureSeries.unique.culture_ship

      put shiny_profiles.profile_path( user.username ), params: {
        profile: {
          public_name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_profiles.edit_profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_profiles.profiles.update.success' )
      expect( response.body ).to have_field 'profile[public_name]', with: new_name
    end

    it 'fails gracefully if required details are missing' do
      user = create :user
      sign_in user

      put shiny_profiles.profile_path( user.username ), params: {
        profile: {
          new_link_url: 'http://example.com'
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_profiles.profiles.update.failure' )
    end
  end
end
