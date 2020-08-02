# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShinyForms', type: :request do
  describe 'POST /form/testing' do
    it 'processes the form data' do
      skip 'whut'

      create :top_level_page
      form = create :plain_text_email_form

      post shiny_forms.process_form_path( form.slug ), params: {
        shiny_form: {
          name: Faker::Name.unique.name,
          email: Faker::Internet.unique.email,
          subject: Faker::Books::CultureSeries.unique.culture_ship,
          message: Faker::Lorem.paragraphs.join("\n\n")
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
    end
  end
end
