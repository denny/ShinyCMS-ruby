# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the Blazer integration
RSpec.describe 'Blazer (charts and dashboards)', type: :request do
  describe 'GET /stats' do
    context 'when logged in as a stats admin user' do
      before do
        admin = create :stats_admin
        sign_in admin
      end

      it 'generates the correct button link' do
        get blazer_path

        expect( response      ).to have_http_status :ok
        # FIXME: setting @page_title in _breadcrumbs.html.erb isn't being picked up by _head.html.erb
        # expect( response.body ).to have_title I18n.t( 'admin.blazer.queries' )
        expect( response.body ).to have_link I18n.t( 'admin.stats.breadcrumb' )
        expect( response.body ).to have_link 'New Query', href: '/admin/stats/queries/new'
      end
    end

    context 'when logged in as an admin user without stats access' do
      before do
        admin = create :page_admin
        sign_in admin
      end

      it 'does not allow access' do
        get blazer_path

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to '/admin'
        follow_redirect!
        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to '/admin/pages'
        follow_redirect!
        expect( response      ).to have_http_status :ok
        # FIXME: losing alert on double-redirect?
        # expect( response.body ).to have_css '.alerts', text: I18n.t( 'admin.blazer.auth_fail' )
      end
    end
  end
end
