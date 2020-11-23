# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the Blazer integration
RSpec.describe 'Blazer (charts and dashboards)', type: :request do
  context 'as a stats admin user' do
    before :each do
      admin = create :stats_admin
      sign_in admin
    end

    describe 'GET /stats' do
      it 'succeeds' do
        get blazer_path

        expect( response      ).to have_http_status :ok
        # FIXME: setting @page_title in _breadcrumbs.html.erb isn't being picked up by _head.html.erb
        # expect( response.body ).to have_title I18n.t( 'admin.blazer.queries' )
        expect( response.body ).to have_css 'a', text: I18n.t( 'admin.stats.breadcrumb' )
      end
    end

    describe 'GET /stats' do
      it 'generates the correct button link' do
        get blazer_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_link 'New Query', href: '/admin/stats/queries/new'
      end
    end
  end

  context 'as an admin user without access to the stats feature' do
    before :each do
      admin = create :admin_user
      sign_in admin
    end

    it 'does not allow access' do
      get blazer_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to '/admin'
      # TODO: FIXME: Something about this redirect is weird; rspec won't follow it, claims it's nil
      # follow_redirect!
      # expect( response      ).to have_http_status :ok
      # expect( response.body ).to have_css '.alerts', text: I18n.t( 'admin.blazer.auth_fail' )
    end
  end
end
