require 'rails_helper'

RSpec.describe 'User', type: :request do
  describe 'GET /user' do
    it 'redirects to the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'allow_user_logins' )
      ).update!( value: 'Yes' )

      get '/user'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_login_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end

    it "renders the user's profile page when a user is already logged in" do
      create :page
      # TODO: factory for logged in users
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[email]': user.email,
        'user[password]': user.password
      }

      expect( response      ).to have_http_status :found
      # TODO: make this behaviour actually happen
      # expect( response      ).to redirect_to user_profile_path( user )
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include "<a href=\"/user/#{user.username}\""
      expect( response.body ).to include '<a href="/logout">log out</a>'

      get '/user'
    end
  end

  describe 'GET /users' do
    it 'redirects to the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'allow_user_logins' )
      ).update!( value: 'Yes' )

      get '/users'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_login_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end
  end

  describe 'GET /login' do
    it 'renders the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'allow_user_logins' )
      ).update!( value: 'Yes' )

      get user_login_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end

    it 'redirects to the site homepage if user logins are not enabled' do
      skip 'not implemented yet'

      Setting.find_or_create_by!(
        name: I18n.t( 'allow_user_logins' )
      ).update!( value: 'No' )

      get user_login_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response.body ).to include 'User logins are not enabled'
      expect( response.body ).to include 'This site does not have any content'
    end

    it 'defaults to assuming that user logins are not enabled' do
      skip 'not implemented yet'

      get user_login_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response.body ).to include 'User logins are not enabled'
      expect( response.body ).to include 'This site does not have any content'
    end
  end

  describe 'GET /user/:username' do
    it "renders the user's profile page" do
      user = create :user

      get user_profile_path( user )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end

  describe 'POST /user/login' do
    it 'logs the user in' do
      create :page
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[email]': user.email,
        'user[password]': password
      }

      expect( response      ).to have_http_status :found
      # TODO: make this behaviour actually happen
      # expect( response      ).to redirect_to user_profile_path( user )
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include "<a href=\"/user/#{user.username}\""
      expect( response.body ).to include '<a href="/logout">log out</a>'
    end
  end
end
