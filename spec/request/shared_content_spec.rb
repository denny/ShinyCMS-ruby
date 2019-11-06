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
      expect( response.body ).to match %r{<h1>\s*#{page.title}\s*</h1>}
      expect( response.body ).to match %r{<p class="small">\s*#{shared.content}\s*</p>}
    end
  end
end
