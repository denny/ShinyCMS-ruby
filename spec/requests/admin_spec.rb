# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin controller:', type: :request do
  describe 'GET /' do
    it 'shows the admin toolbar on the main site, if you are an admin' do
      create :top_level_page
      admin = create :page_admin
      sign_in admin

      get root_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.shinycms-admin-toolbar'
    end

    it 'does not show the admin toolbar on the main site, if you are not an admin' do
      create :top_level_page

      get root_path

      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css '.shinycms-admin-toolbar'
    end
  end

  describe 'GET /admin' do
    it 'redirects a non-admin to the main site' do
      user = create :user
      sign_in user

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end

    it 'redirects to the user-configured post_login_redirect, if one is set' do
      admin = create :page_admin
      sign_in admin

      Setting.find_by( name: 'post_login_redirect' )
             .values.create!( user_id: admin.id, value: '/admin/page/new' )

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to new_page_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.new.title' ).titlecase
    end
  end

  describe 'GET /admin with IP protection enabled' do
    it 'redirects to the admin area when a matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      Setting.set( :admin_ip_list, to: '127.0.0.1' )

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end

    it 'redirects to the main site when a non-matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      Setting.set( :admin_ip_list, to: '10.10.10.10' )

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end
  end

  describe 'GET /admin redirects to the appropriate admin area for:' do
    # type, path, section
    include_examples '/admin redirect', 'page_admin', '/admin/pages', 'pages'
    include_examples '/admin redirect', 'user_admin', '/admin/users', 'users'
    include_examples '/admin redirect', 'settings_admin', '/admin/site-settings', 'site_settings'

    # type, path, section, plugin
    include_examples '/admin redirect', 'blog_admin', '/admin/blog_posts', 'blog_posts', 'shiny_blog'
    include_examples '/admin redirect', 'form_admin', '/admin/forms',      'forms',      'shiny_forms'
    include_examples '/admin redirect', 'news_admin', '/admin/news_posts', 'news_posts', 'shiny_news'
  end
end
