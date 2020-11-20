# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the Blazer integration
RSpec.describe 'Blazer (charts and dashboards)', type: :request do
  before :each do
    admin = create :stats_admin
    sign_in admin
  end

  describe 'GET /stats' do
    it 'succeeds' do
      get blazer_path

      expect( response      ).to have_http_status :ok
      # TODO: such test, wow
      expect( response.body ).to have_title 'Queries'
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
