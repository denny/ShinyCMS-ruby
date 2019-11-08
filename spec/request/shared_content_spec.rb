require 'rails_helper'

RSpec.describe 'Shared Content', type: :request do
  describe 'GET / with a shared content element' do
    it 'fetches the page, including the content of the shared element' do
      page   = create :top_level_page
      shared = create :shared_content_element,
                      name: 'email',
                      content: Faker::Internet.unique.email

      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.title
      expect( response.body ).to have_css '.small', text: shared.content
    end
  end
end
