# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShinyForms Admin', type: :request do
  before :each do
    admin = create :form_admin
    sign_in admin
  end

  describe 'GET /admin/forms' do
    it 'loads the list of form handlers' do
      get shiny_forms.forms_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase
    end
  end

  describe 'GET /admin/forms/new' do
    it 'loads the page to add a new form handler' do
      get shiny_forms.new_form_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.new.title' ).titlecase
    end
  end

  describe 'POST /admin/forms' do
    it 'adds a new form when the appropriate details are submitted' do
      post shiny_forms.forms_path, params: {
        form: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          handler: 'plain_text_email'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_forms.edit_form_path( ShinyForms::Form.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_forms.admin.forms.create.success' )
    end

    it 'fails when the form is submitted without all the details' do
      post shiny_forms.forms_path, params: {
        form: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_forms.admin.forms.create.failure' )
    end
  end

  describe 'GET /admin/forms/:id/edit' do
    it 'loads the page to edit an existing form handler' do
      form = create :plain_text_email_form

      get shiny_forms.edit_form_path( form )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
    end
  end
end
