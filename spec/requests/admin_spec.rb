require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  before :each do
    admin = create :page_admin
    sign_in admin
  end

  describe 'GET /admin' do
    it 'redirects to the page admin area' do
      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end

    it 'still works with an admin IP list set' do
      Setting.find_or_create_by!(
        name: I18n.t( 'admin.settings.admin_ip_list' )
      ).update!( value: '127.0.0.1' )

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end

    it 'fails with a blocking admin IP list set' do
      Setting.find_or_create_by!(
        name: I18n.t( 'admin.settings.admin_ip_list' )
      ).update!( value: '10.10.10.10' )

      get admin_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'This site does not have any content'
    end
  end
end
