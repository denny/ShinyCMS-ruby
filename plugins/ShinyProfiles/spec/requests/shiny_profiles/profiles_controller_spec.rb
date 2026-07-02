# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site controller
RSpec.describe ShinyProfiles::ProfilesController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :user_login
    ShinyCMS::FeatureFlag.enable :user_profiles
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
      expect( response.body ).to have_title I18n.t( 'shinycms.errors.not_found.title', resource_type: 'Page' )
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

    context 'when the username in the URL is not the logged-in user' do
      it 'redirects to the view profile page for that username' do
        user1 = create :user
        user2 = create :user
        sign_in user2

        get shiny_profiles.edit_profile_path( user1.username )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shiny_profiles.profile_path( user1.username )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title user1.profile.name
      end
    end
  end

  describe 'GET /profile' do
    context 'when a user is not logged in' do
      it 'redirects to the login page' do
        get shiny_profiles.profile_redirect_path

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shinycms.new_user_session_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_button I18n.t( 'shinycms.user.log_in' )
      end
    end

    context 'when a user is logged in' do
      it "redirects to the current user's profile page" do
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

    context "when a logged-in user attempts to update somebody else's profile" do
      it 'they get redirected to their own profile edit page' do
        user1 = create :user
        user2 = create :user
        sign_in user2

        new_name = Faker::Books::CultureSeries.unique.culture_ship

        put shiny_profiles.profile_path( user1.username ), params: {
          profile: {
            public_name: new_name
          }
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shiny_profiles.edit_profile_path( user2.username )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title user2.profile.name
      end
    end

    it 'adds profile links' do
      user = create :user
      sign_in user

      name1 = Faker::Books::CultureSeries.culture_ship
      name2 = Faker::Books::CultureSeries.culture_ship
      url1  = Faker::Internet.url
      url2  = Faker::Internet.url

      put shiny_profiles.profile_path( user.username ), params: {
        profile: {
          public_name:   nil, # Blows up without this?
          new_link_name: [ name1, name2 ],
          new_link_url:  [ url1,  url2  ]
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_profiles.edit_profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_profiles.profiles.update.success' )
      expect( response.body ).to have_field 'profile[links_attributes][0][name]', with: name1
    end
  end
end
