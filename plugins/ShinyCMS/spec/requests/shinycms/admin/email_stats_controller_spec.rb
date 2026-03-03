# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for viewing email stats in admin area
RSpec.describe ShinyCMS::Admin::EmailStatsController, type: :request do
  before do
    admin = create :stats_admin
    sign_in admin
  end

  describe 'GET /admin/email-stats' do
    it 'fetches the email stats page in the admin area' do
      get shinycms.email_stats_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_stats.index.title' ).titlecase
    end

    it 'fetches the email stats for a specific user' do
      user = create :user

      get shinycms.user_email_stats_path( user.id )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_stats.index.title' ).titlecase
    end

    it 'fetches the email stats for a specific recipient (without a user account)' do
      recipient = create :email_recipient, :confirmed

      get shinycms.recipient_email_stats_path( recipient.id )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_stats.index.title' ).titlecase
    end
  end

  describe 'GET /admin/email-stats/search?q=banana' do
    it 'fetches the stats with matching details' do
      # TODO: factory for ahoy messages

      get shinycms.search_email_stats_path, params: { q: 'banana' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.email_stats.index.title' ).titlecase

      # expect( response.body ).to     have_css 'td', text: 'apple'
      expect( response.body ).not_to have_css 'td', text: 'banana'
    end
  end
end
