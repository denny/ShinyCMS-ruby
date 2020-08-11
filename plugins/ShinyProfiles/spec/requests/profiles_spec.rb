# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User profiles', type: :request do
  before :all do
    FeatureFlag.enable :user_login
    FeatureFlag.enable :profile_pages
  end

  describe 'GET /profiles' do
    it 'redirects to the site homepage until the profile gallery feature is built :)' do
      page = create :top_level_page

      get shiny_profiles.profiles_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
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
      expect( response.body ).to include user.username
    end

    it "renders the CMS 404 page if the username doesn't exist" do
      get shiny_profiles.profile_path( 'syzygy' )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t( 'errors.not_found.title', resource_type: 'Profile' )
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
      expect( response.body ).to include user.username
    end
  end
end
