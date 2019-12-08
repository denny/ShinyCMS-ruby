require 'rails_helper'

RSpec.describe 'Feature Flags', type: :request do
  describe 'GET /login' do
    it "succeeds with 'User Login = On'" do
      create :feature_flag, name: I18n.t( 'feature.user_login' ), enabled: true

      get user_login_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include I18n.t( 'user.log_in' )
    end

    it "fails with 'User Login = Off'" do
      create :top_level_page

      create :feature_flag, name: I18n.t( 'feature.user_login' ), enabled: false

      get user_login_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '#alerts',
        text: I18n.t(
          'feature.off_alert',
          feature_name: I18n.t( 'feature.user_login' )
        )
      )
    end
  end

  describe 'GET /user/{username}' do
    it 'fails for non-admin user with User Profiles feature only enabled for admins' do
      create :top_level_page
      user = create :user
      sign_in user

      create :feature_flag, name: I18n.t( 'feature.user_profiles' ), enabled_for_admins: true

      get user_profile_path( user.username )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css(
        '#alerts',
        text: I18n.t(
          'feature.off_alert',
          feature_name: I18n.t( 'feature.user_profiles' )
        )
      )
    end

    it 'succeeds for admin user with User Profiles feature only enabled for admins' do
      user = create :admin_user
      sign_in user

      create :feature_flag, name: I18n.t( 'feature.user_profiles' ), enabled_for_admins: true
      get user_profile_path( user.username )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include user.username
    end
  end
end
