# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe 'Flipper (feature flags)', type: :request do
  describe 'GET /admin/tools/flipper' do
    context 'when logged in as a feature flags admin' do
      before do
        admin = create :feature_flags_admin
        sign_in admin
      end

      it 'reaches Flipper' do
        get shinycms.flipper_path

        flipper_features_path = "#{shinycms.flipper_path}/features"

        expect( response ).to have_http_status :found
        expect( response ).to redirect_to flipper_features_path
        follow_redirect!
        expect( response ).to have_http_status :ok
      end
    end

    context 'when logged in as an admin user without access to feature flags' do
      before do
        admin = create :page_admin
        sign_in admin
      end

      it 'does not reach Flipper' do
        get shinycms.flipper_path

        expect( response ).to have_http_status :found
        expect( response ).to redirect_to shinycms.admin_path
        follow_redirect!
        expect( response ).to have_http_status :found
        expect( response ).to redirect_to shiny_pages.pages_path
        follow_redirect!
        expect( response ).to have_http_status :ok
      end
    end
  end
end
