# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the web stats controller
RSpec.describe Admin::WebStatsController, type: :request do
  before do
    admin = create :stats_admin
    sign_in admin
  end

  describe 'GET /admin/web-stats' do
    it 'fetches the web stats page in the admin area' do
      get web_stats_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.web_stats.index.title' ).titlecase
    end

    it 'fetches the web stats for a specific user' do
      user = create :user

      get user_web_stats_path( user.id )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.web_stats.index.title' ).titlecase
    end
  end

  describe 'GET /admin/web-stats/search?q=banana' do
    it 'fetches the stats with matching details' do
      # TODO: factory for ahoy visits

      get search_web_stats_path, params: { q: 'banana' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.web_stats.index.title' ).titlecase

      # expect( response.body ).to     have_css 'td', text: 'apple'
      expect( response.body ).not_to have_css 'td', text: 'banana'
    end
  end
end
