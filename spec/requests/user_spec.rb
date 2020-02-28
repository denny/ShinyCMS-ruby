require 'rails_helper'

RSpec.describe 'User', type: :request do
  before :each do
    FeatureFlag.find_or_create_by!( name: 'user_login' )
               .update!( enabled: true )
    FeatureFlag.find_or_create_by!( name: 'user_profiles' )
               .update!( enabled: true )

    @v2_secret = ENV.delete( 'RECAPTCHA_V2_SECRET_KEY' )
    @v2_site   = ENV.delete( 'RECAPTCHA_V2_SITE_KEY'   )
    @v3_secret = ENV.delete( 'RECAPTCHA_V3_SECRET_KEY' )
    @v3_site   = ENV.delete( 'RECAPTCHA_V3_SITE_KEY'   )
  end

  after :each do
    ENV.delete( 'RECAPTCHA_V2_SECRET_KEY' ) if @v2_secret.nil?
    ENV.delete( 'RECAPTCHA_V2_SITE_KEY'   ) if @v2_site.nil?
    ENV.delete( 'RECAPTCHA_V3_SECRET_KEY' ) if @v3_secret.nil?
    ENV.delete( 'RECAPTCHA_V3_SITE_KEY'   ) if @v3_site.nil?

    ENV['RECAPTCHA_V2_SECRET_KEY'] = @v2_secret unless @v2_site.nil?
    ENV['RECAPTCHA_V2_SITE_KEY'  ] = @v2_site   unless @v2_site.nil?
    ENV['RECAPTCHA_V3_SECRET_KEY'] = @v3_secret unless @v3_site.nil?
    ENV['RECAPTCHA_V3_SITE_KEY'  ] = @v3_site   unless @v3_site.nil?
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

    it 'renders the user registration page if user registrations are enabled' do
      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      get new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.register' )
    end

    it 'includes the V3 reCAPTCHA code if a V3 key was set' do
      ENV[ 'RECAPTCHA_V3_SITE_KEY' ] = 'abcdefg1234bleurgh'

      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      get new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.register' )
      # TODO: look for V3 html
    end

    it 'includes the V2 reCAPTCHA code if only a V2 key was set' do
      ENV[ 'RECAPTCHA_V2_SITE_KEY' ] = 'abcdefg1234bleurgh'

      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      get new_user_registration_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_button I18n.t( 'user.register' )
      # TODO: look for V2 html
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
    it 'creates a new user, checking V3 reCAPTCHA if a V3 key is set' do
      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      create :page

      username = Faker::Science.unique.element.downcase
      password = 'shinycms unimaginative test passphrase'
      email = "#{username}@example.com"

      ENV['RECAPTCHA_V3_SECRET_KEY'] = 'ABC'
      ENV['RECAPTCHA_V3_SITE_KEY']   = 'XZY'

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

    it 'creates a new user, checking V2 invisible reCAPTCHA if no V3 key present' do
      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      create :page

      username = Faker::Science.unique.element.downcase
      password = 'shinycms unimaginative test passphrase'
      email = "#{username}@example.com"

      ENV['RECAPTCHA_V2_SECRET_KEY'] = 'ABC'
      ENV['RECAPTCHA_V2_SITE_KEY']   = 'ZYX'

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

    it 'falls back to checkbox reCAPTCHA if invisible reCAPTCHA fails' do
      allow_any_instance_of( RecaptchaHelper )
        .to receive( :verify_invisible_recaptcha ).and_return( false )

      allow_any_instance_of( RecaptchaHelper )
        .to receive( :verify_checkbox_recaptcha ).and_return( false )

      FeatureFlag.find_or_create_by!( name: 'user_registration' )
                 .update!( enabled: true )

      create :top_level_page

      username = Faker::Science.unique.element.downcase
      password = 'shinycms unimaginative test passphrase'
      email = "#{username}@example.com"

      ENV['RECAPTCHA_V2_SECRET_KEY'] = 'ABC'
      ENV['RECAPTCHA_V2_SITE_KEY']   = 'ZYX'
      ENV['RECAPTCHA_V3_SECRET_KEY'] = 'DEF'
      ENV['RECAPTCHA_V3_SITE_KEY']   = 'WVU'

      post user_registration_path, params: {
        'user[username]': username,
        'user[password]': password,
        'user[email]': email
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to new_user_registration_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'textarea.g-recaptcha-response'

      allow_any_instance_of( RecaptchaHelper )
        .to receive( :verify_checkbox_recaptcha ).and_return( true )
      # .to receive( :verify_checkbox_recaptcha ).and_call_original

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
