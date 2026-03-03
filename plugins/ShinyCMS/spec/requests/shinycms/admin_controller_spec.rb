# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for some basic/generic admin features
RSpec.describe ShinyCMS::Admin::RootController, type: :request do
  describe 'GET /' do
    it 'shows the admin toolbar on the main site, if you are an admin' do
      create :top_level_page
      admin = create :page_admin
      sign_in admin

      get main_app.root_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.shinycms-admin-toolbar'
    end

    it 'does not show the admin toolbar on the main site, if you are not an admin' do
      create :top_level_page

      get main_app.root_path

      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css '.shinycms-admin-toolbar'
    end
  end

  describe 'GET /admin' do
    it 'redirects a non-admin to the main site' do
      user = create :user
      sign_in user

      get shinycms.admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end

    it 'redirects a page admin to the admin pages+sections list' do
      admin = create :page_admin
      sign_in admin

      get shinycms.admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
    end
  end

  describe 'GET /admin with IP protection enabled' do
    it 'redirects to the admin area when a matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      ShinyCMS::Setting.set( :allowed_ips, to: '127.0.0.1' )

      get shinycms.admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.index.title' ).titlecase
    end

    it 'redirects to the main site when a non-matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      ShinyCMS::Setting.set( :allowed_ips, to: '10.10.10.10' )

      get shinycms.admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end
  end

  describe 'GET /admin/does/not/exist' do
    it 'redirects to /admin with an error message' do
      admin = create :page_admin
      sign_in admin

      get '/admin/does/not/exist'

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.admin_path
      follow_redirect!
      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert', text: I18n.t( 'shinycms.admin.invalid_url', request_path: 'does/not/exist' )
    end
  end
end
