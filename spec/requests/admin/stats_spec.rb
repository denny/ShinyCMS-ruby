require 'rails_helper'

RSpec.describe 'Stats', type: :request do
  before :each do
    admin = create :admin_user
    sign_in admin
  end

  describe 'GET /stats' do
    it 'succeeds' do
      get blazer_path

      expect( response      ).to have_http_status :ok
      # TODO: such test, wow
      # expect( response.body ).to have_title I18n.t( 'admin.stats.title' )
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
