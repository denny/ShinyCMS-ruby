# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for viewing email stats in admin area
RSpec.describe Admin::EmailStatsController, type: :request do
  before :each do
    admin = create :stats_admin
    sign_in admin
  end

  describe 'GET /admin/email-stats' do
    it 'fetches the email stats page in the admin area' do
      get email_stats_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.email_stats.index.title' ).titlecase
    end

    it 'fetches the email stats for a specific user' do
      user = create :user

      get email_stats_path, params: { user_id: user.id }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.email_stats.index.title' ).titlecase
    end

    it 'fetches the email stats for a specific recipient (without a user account)' do
      user = create :email_recipient

      get email_stats_path, params: { user_id: user.id, user_type: 'EmailRecipient' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.email_stats.index.title' ).titlecase
    end
  end
end
