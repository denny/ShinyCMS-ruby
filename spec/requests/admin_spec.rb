require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  describe 'GET /admin' do
    it 'redirects to admin area when a matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      setting = create :setting, name: 'admin_ip_list'
      create :setting_value, setting_id: setting.id, value: '127.0.0.1'

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end

    it 'refuses to redirect to admin area when a non-matching admin IP list is set' do
      admin = create :page_admin
      sign_in admin

      setting = create :setting, name: 'admin_ip_list'
      create :setting_value, setting_id: setting.id, value: '10.10.10.10'

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end
  end

  describe 'GET /admin redirects to the appropriate admin area for a:' do
    it 'blog admin' do
      admin = create :blog_admin
      sign_in admin

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to blogs_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.index.title' ).titlecase
    end

    it 'page admin' do
      admin = create :page_admin
      sign_in admin

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end

    it 'settings admin' do
      create :setting, name: 'theme_name'
      admin = create :settings_admin
      sign_in admin

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_site_settings_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
    end

    it 'user admin' do
      admin = create :user_admin
      sign_in admin

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to users_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.users.index.title' ).titlecase
    end
  end
end
