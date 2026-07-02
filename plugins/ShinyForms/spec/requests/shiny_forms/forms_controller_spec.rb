# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyForms::FormsController, type: :request do
  before do
    create :top_level_page

    akismet_client = instance_double( Akismet::Client, open: nil, check: [ false, false ] )
    allow( Akismet::Client ).to receive( :new ).and_return( akismet_client )
    allow( described_class ).to receive( :recaptcha_v3_secret_key ).and_return( 'A_KEY' )
  end

  describe 'GET /contact-form' do
    it 'loads a page with a ShinyForm embedded' do
      template1 = create :page_template, filename: 'contact_form'
      page1 = create :top_level_page, template: template1
      create :plain_email_form, slug: 'contact'

      get "/#{page1.slug}"

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /form/testing' do
    context 'with form.handler = plain_email' do
      it 'sends a plain email (dump of form_data)' do
        form = create :plain_email_form

        post shiny_forms.process_form_path( form.slug ), params: {
          shiny_form: {
            name:    Faker::Name.unique.name,
            email:   Faker::Internet.unique.email,
            subject: Faker::Books::CultureSeries.unique.culture_ship,
            message: Faker::Lorem.paragraphs.join( "\n\n" )
          }
        }

        expect( response ).to have_http_status :found
        expect( response ).to redirect_to main_app.root_path
        follow_redirect!
        expect( response ).to have_http_status :ok
        expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
      end
    end

    context 'with form.handler = template_email' do
      it 'sends a templated email' do
        form = create :template_email_form

        post shiny_forms.process_form_path( form.slug ), params: {
          shiny_form: {
            name:    Faker::Name.unique.name,
            email:   Faker::Internet.unique.email,
            subject: Faker::Books::CultureSeries.unique.culture_ship,
            message: Faker::Lorem.paragraphs.join( "\n\n" )
          }
        }

        expect( response ).to have_http_status :found
        expect( response ).to redirect_to main_app.root_path
        follow_redirect!
        expect( response ).to have_http_status :ok
        expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
      end
    end

    it 'redirects as configured' do
      form = create :plain_email_form, redirect_to: main_app.root_path

      post shiny_forms.process_form_path( form.slug ), params: {
        shiny_form: {
          email:   Faker::Internet.unique.email,
          message: Faker::Lorem.paragraph
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_forms.forms.process_form.success' )
    end

    it 'catches misconfigured form handlers' do
      form = create :plain_email_form, handler: 'does_not_exist'

      post shiny_forms.process_form_path( form.slug ), params: {
        shiny_form: {
          message: Faker::Lorem.paragraph
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_forms.forms.process_form.failure' )
    end

    it 'handles non-existent form slugs' do
      post shiny_forms.process_form_path( 'this-form-does-not-exist' ), params: {
        shiny_form: {
          message: Faker::Lorem.paragraph
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_forms.forms.process_form.form_not_found' )
    end
  end
end
