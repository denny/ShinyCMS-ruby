# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the Blazer integration
RSpec.describe 'Blazer (charts and dashboards)', type: :request do
  describe 'GET /admin/tools/blazer' do
    context 'when logged in as an admin user with access to Blazer' do
      before do
        admin = create :tools_admin
        sign_in admin
      end

      it 'generates the correct button link' do
        blazer_base_path = '/admin/tools/blazer'

        get blazer_base_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.blazer.queries.title' )
        expect( response.body ).to have_link  I18n.t( 'shinycms.admin.blazer.breadcrumb' )
        expect( response.body ).to have_link 'New Query', href: "#{blazer_base_path}/queries/new"
      end
    end

    context 'when logged in as an admin user without access to the tools' do
      before do
        admin = create :page_admin
        sign_in admin
      end

      it 'does not allow access' do
        blazer_base_path = '/admin/tools/blazer'

        get blazer_base_path

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to '/admin'
        follow_redirect!
        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shiny_pages.pages_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_css '.alert', text: I18n.t( 'shinycms.admin.blazer.auth_fail' )
      end
    end
  end
end
