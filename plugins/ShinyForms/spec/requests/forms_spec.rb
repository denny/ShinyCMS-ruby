# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShinyForms', type: :request do
  before :each do
    create :top_level_page
  end

  describe 'POST /form/testing' do
    it 'processes the form data' do
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
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
    end

    it 'can send MJML templated emails' do
      form = create :mjml_template_email_form, filename: 'contact_form'

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
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
    end

    it 'redirects as configured' do
      form = create :plain_text_email_form, redirect_to: root_path

      post shiny_forms.process_form_path( form.slug ), params: {
        shiny_form: {
          email: Faker::Internet.unique.email,
          message: Faker::Lorem.paragraph
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
    end

    it 'catches misconfigured form handlers' do
      form = create :plain_text_email_form, handler: 'does_not_exist'

      post shiny_forms.process_form_path( form.slug ), params: {
        shiny_form: {
          message: Faker::Lorem.paragraph
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_forms.forms.process_form.failure' )
    end
  end
end
