# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the web stats controller
RSpec.describe ShinyCMS::Admin::WebStatsController, type: :request do
  before do
    admin = create :stats_admin
    sign_in admin
  end

  describe 'GET /admin/web-stats' do
    context 'when there are no web stats' do
      it "displays the 'no web stats found' message" do
        get shinycms.web_stats_path

        pager_info = 'No visits found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.web_stats.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are web stats' do
      it 'displays the web stats' do
        # TODO: factory for ahoy visits
        # create_list :ahoy_visit, 3

        get shinycms.web_stats_path

        # pager_info = 'Displaying 3 visits'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.web_stats.index.title' ).titlecase
        # expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/web-stats/123' do
    it 'fetches the web stats for a specific user' do
      visitor = create :user
      # TODO: factory for ahoy visits
      # create :ahoy_visit, user_id: visitor.id

      get shinycms.user_web_stats_path( visitor.id )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.web_stats.index.title' ).titlecase
      # expect( response.body ).to have_css 'td', text: visitor.username
    end
  end

  describe 'GET /admin/web-stats/search?q=banana' do
    it 'fetches the stats with matching details' do
      # TODO: factory for ahoy visits
      # create :ahoy_visit, landing_page: 'apple'
      # create :ahoy_visit, landing_page: 'banana'

      get shinycms.search_web_stats_path, params: { q: 'banana' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.web_stats.index.title' ).titlecase

      # expect( response.body ).to     have_css 'td', text: 'apple'
      expect( response.body ).not_to have_css 'td', text: 'banana'
    end
  end
end
