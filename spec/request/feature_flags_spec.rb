require 'rails_helper'

RSpec.describe 'Feature Flags', type: :request do
  describe 'GET /login' do
    it "succeeds with 'User Login = On'" do
      create :feature_flag, name: 'User Login', enabled: true

      get user_login_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'users.log_in' )
    end

    it "fails with 'User Login = Off'" do
      page = create :top_level_page

      create :feature_flag, name: 'User Login', enabled: false

      get user_login_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.title
    end
  end

  describe 'GET /user/{username}' do
    it "fails for non-admin user with 'User Profiles = Admin Only'" do
      skip 'Need admin users to test this'
      page = create :top_level_page
      user = create :user
      sign_in user

      create :feature_flag, name: 'User Login', enabled_for_admins: true

      get user_profile_path( user.username )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.title
    end

    it "succeeds for admin user with 'User Profiles = Admin Only'" do
      user = create :user
      sign_in user

      create :feature_flag, name: 'User Login', enabled_for_admins: true

      get user_profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end
end
