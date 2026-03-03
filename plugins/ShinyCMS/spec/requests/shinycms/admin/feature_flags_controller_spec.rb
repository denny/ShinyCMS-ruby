# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for feature flags administration
RSpec.describe ShinyCMS::Admin::FeatureFlagsController, type: :request do
  before do
    admin = create :feature_flags_admin
    sign_in admin
  end

  describe 'GET /admin/feature-flags' do
    it 'fetches the feature flags page in the admin area' do
      ShinyCMS::FeatureFlag.enable :user_login

      get shinycms.feature_flags_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.feature_flags.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/feature-flags' do
    it 'updates any feature flags that were changed' do
      flag = ShinyCMS::FeatureFlag.enable :user_registration

      put shinycms.feature_flags_path, params: {
        "features[flags][#{flag.id}][enabled]":               true,
        "features[flags][#{flag.id}][enabled_for_logged_in]": true,
        "features[flags][#{flag.id}][enabled_for_admins]":    true
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.feature_flags_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.feature_flags.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.feature_flags.update.success' )
    end

    it 'fails gracefully if an update is invalid' do
      flag = ShinyCMS::FeatureFlag.enable :user_registration

      put shinycms.feature_flags_path, params: {
        "features[flags][#{flag.id}][enabled]": nil
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shinycms.feature_flags_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shinycms.admin.feature_flags.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'shinycms.admin.feature_flags.update.failure' )
    end
  end
end
