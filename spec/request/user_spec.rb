require 'rails_helper'

RSpec.describe 'User', type: :request do
  describe 'GET /user/:username' do
    it "renders the user's profile page" do
      user = create :user

      get user_profile_path( user )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end

  describe 'GET /login' do
    it 'renders the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'settings.allow_user_logins' )
      ).update!( value: 'Yes' )

      get user_login_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end

    it 'redirects to the site homepage if user logins are not enabled' do
      create :page

      Setting.find_or_create_by!(
        name: I18n.t( 'settings.allow_user_logins' )
      ).update!( value: 'No' )

      get user_login_path

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to root_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css '#alerts', text: I18n.t( 'users.logins_not_enabled' )
      expect( response.body ).not_to include 'Login'
    end

    it 'defaults to assuming that user logins are not enabled' do
      create :page

      Setting.delete_by( name: I18n.t( 'settings.allow_user_logins' ) )

      get user_login_path

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to root_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css '#alerts', text: I18n.t( 'users.logins_not_enabled' )
      expect( response.body ).not_to include 'Login'
    end
  end

  describe 'GET /users' do
    it 'redirects to the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'settings.allow_user_logins' )
      ).update!( value: 'Yes' )

      get '/users'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_login_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end
  end

  describe 'GET /user' do
    it 'redirects to the user login page if user logins are enabled' do
      Setting.find_or_create_by!(
        name: I18n.t( 'settings.allow_user_logins' )
      ).update!( value: 'Yes' )

      get '/user'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_login_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'Log in'
    end

    it "redirects to the user's profile page when user is already logged in" do
      user = create :user
      sign_in user

      get '/user'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end

  describe 'POST /user/login' do
    it 'logs the user in using their email address' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[login]': user.email,
        'user[password]': password
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include "<a href=\"/user/#{user.username}\""
      expect( response.body ).to include '<a href="/logout">Log out</a>'
    end

    it 'logs the user in using their username' do
      password = 'shinycms unimaginative test passphrase'
      user = create :user, password: password

      post user_session_path, params: {
        'user[login]': user.username,
        'user[password]': password
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to user_profile_path( user )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include "<a href=\"/user/#{user.username}\""
      expect( response.body ).to include '<a href="/logout">Log out</a>'
    end
  end

  describe 'POST /user/register' do
    it 'creates a new user' do
      create :page

      username = Faker::Science.unique.element.downcase
      password = 'shinycms unimaginative test passphrase'
      email = "#{username}@example.com"

      post user_registration_path, params: {
        'user[username]': username,
        'user[password]': password,
        'user[email]': email
      }

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

  describe 'PUT /user' do
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
      expect( response.body ).to have_css '#notices', text: 'Your account has been updated'
      expect( response.body ).to include new_name
    end
  end
end
