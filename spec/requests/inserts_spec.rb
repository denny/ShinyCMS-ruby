# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Inserts', type: :request do
  describe 'GET /' do
    it 'fetches the page, including the content of the insert element' do
      page   = create :top_level_page
      set    = InsertSet.first
      insert = create :insert_element,
                      set: set,
                      name: 'the_email',
                      content: Faker::Internet.unique.email

      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.title
      expect( response.body ).to have_css '.small', text: insert.content
    end
  end
end
