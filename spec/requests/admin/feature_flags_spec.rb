require 'rails_helper'

RSpec.describe 'Admin: Feature Flags', type: :request do
  before :each do
    admin = create :feature_flags_admin
    sign_in admin
  end

  describe 'GET /admin/feature-flags' do
    it 'fetches the feature flags page in the admin area' do
      create :feature_flag, name: 'user_login'

      get feature_flags_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.feature_flags.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/feature-flags' do
    it 'updates any feature flags that were changed' do
      flag = create :feature_flag, name: 'user_profiles'

      put feature_flags_path, params: {
        "features[flags][#{flag.id}][enabled]": true,
        "features[flags][#{flag.id}][enabled_for_logged_in]": true,
        "features[flags][#{flag.id}][enabled_for_admins]": true
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to feature_flags_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.feature_flags.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.feature_flags.update.success' )
    end

    it 'fails gracefully if an update is invalid' do
      flag = create :feature_flag, name: 'user_profiles'

      put feature_flags_path, params: {
        "features[flags][#{flag.id}][enabled]": nil
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to feature_flags_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.feature_flags.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'admin.feature_flags.update.failure' )
    end
  end
end
