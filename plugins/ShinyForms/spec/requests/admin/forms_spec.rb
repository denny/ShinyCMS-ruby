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

  describe 'GET /admin/forms/:id/edit' do
    it 'loads the page to edit an existing form handler' do
      form = create :form

      get shiny_forms.edit_form_path( form )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
    end
  end
end
