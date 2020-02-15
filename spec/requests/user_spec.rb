require 'rails_helper'

RSpec.describe 'User', type: :request do
  before :each do
    FeatureFlag.find_or_create_by!( name: 'user_login' )
               .update!( enabled: true )
    FeatureFlag.find_or_create_by!( name: 'user_profiles' )
               .update!( enabled: true )
  end

  describe 'GET /user/:username' do
    it "renders the user's profile page" do
      user = create :user

      get user_profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end

    it "renders the CMS 404 page if the username doesn't exist" do
      create :page

      get user_profile_path( 'syzygy' )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t( 'errors.not_found.title', resource_type: 'User' )
    end
  end

  describe 'new user registration' do
    it 'renders the user registration page if user registrations are enabled' do
      ENV[ 'RECAPTCHA_V3_SITE_KEY' ] = 'abcdefg1234bleurgh'

      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      get new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.register' )
    end

    it 'redirects to the site homepage if user registrations are not enabled' do
      create :page

      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: false )

      get new_user_registration_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '.alerts',
        text: I18n.t(
          'feature_flags.off_alert',
          feature_name: I18n.t( 'feature_flags.user_registration' )
        )
      )
      expect( response.body ).not_to have_button I18n.t( 'user.register' )
    end
  end

  describe 'GET /login' do
    it 'renders the user login page if user logins are enabled' do
      get new_user_session_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.log_in' )
    end

    it 'redirects to the site homepage if user logins are not enabled' do
      create :page

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
      expect( response.body ).not_to have_button I18n.t( 'user.log_in' )
    end

    it 'defaults to assuming that user logins are not enabled' do
      create :page

      FeatureFlag.delete_by( name: 'user_login' )

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
  end

  describe 'GET /users' do
    it 'redirects to the user login page if user logins are enabled' do
      get '/users'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to new_user_session_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.log_in' )
    end
  end

  describe 'GET /user' do
    it 'redirects to the user login page if user logins are enabled' do
      get '/user'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to new_user_session_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.log_in' )
    end

    it "redirects to the user's profile page when user is already logged in" do
      user = create :user
      sign_in user

      get '/user'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end

  describe 'POST /user/login' do
    it 'logs the user in using their email address' do
      create :page
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[login]': user.email,
        'user[password]': password
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link user.username, href: "/user/#{user.username}"
      expect( response.body ).to have_link I18n.t( 'user.log_out' )
    end

    it 'logs the user in using their username' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[login]': user.username,
        'user[password]': password
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user.username )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_link user.username, href: "/user/#{user.username}"
      expect( response.body ).to have_link I18n.t( 'user.log_out' )
    end

    it 'redirects back to the referring page after login, if it knows it' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password
      page = create :top_level_page

      should_go_here = "http://www.example.com/#{page.slug}"

      post user_session_path,
           params: {
             'user[login]': user.username,
             'user[password]': password
           },
           headers: {
             'HTTP_REFERER': should_go_here
           }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to should_go_here
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h1', text: page.title
    end
  end

  describe 'POST /user/register' do
    it 'creates a new user' do
      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      create :page

      username = Faker::Science.unique.element.downcase
      password = 'shinycms unimaginative test passphrase'
      email = "#{username}@example.com"

      ENV['FAIL_RECAPTCHA'] = 'FAIL'
      post user_registration_path, params: {
        'user[username]': username,
        'user[password]': password,
        'user[email]': email
      }
      ENV['FAIL_RECAPTCHA'] = nil

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include(
        'a confirmation link has been sent to your email address'
      )
    end
  end

  describe 'GET /user/edit' do
    it 'loads the user edit page' do
      user = create :user
      sign_in user

      get edit_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Edit User'
    end
  end

  describe 'PUT /user/update' do
    it 'updates the user when you submit the edit form' do
      user = create :user
      sign_in user

      new_name = Faker::Science.unique.scientist
      put user_registration_path, params: {
        'user[display_name]': new_name,
        'user[current_password]': user.password
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_user_registration_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'devise.registrations.updated' )
      expect( response.body ).to include new_name
    end
  end
end
