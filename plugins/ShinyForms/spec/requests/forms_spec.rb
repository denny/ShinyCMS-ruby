# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShinyForms', type: :request do
  describe 'POST /form/testing' do
    it 'processes the form data' do
      create :top_level_page
      create :plain_text_email_form

      post form_path, params: {
        email: Faker::Internet.unique.email,
        subject: Faker::Books::CultureSeries.unique.culture_ship,
        message: Faker::Lorem.paragraph( count: 3 )
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
    end
  end
end
