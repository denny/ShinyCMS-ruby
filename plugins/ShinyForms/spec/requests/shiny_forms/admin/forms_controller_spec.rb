# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyForms::Admin::FormsController, type: :request do
  before do
    admin = create :form_admin
    sign_in admin
  end

  describe 'GET /admin/forms' do
    context 'when there are no forms' do
      it "displays the 'no forms found' message" do
        get shiny_forms.forms_path

        pager_info = 'No forms found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are forms' do
      it 'displays the list of forms' do
        create_list :form, 3

        get shiny_forms.forms_path

        pager_info = 'Displaying 3 forms'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/forms/search?q=zing' do
    it 'fetches the list of matching form handlers' do
      form1 = create :form, slug: 'zingy-zebras'
      form2 = create :form, slug: 'awesome-aardvarks'

      get shiny_forms.search_forms_path, params: { q: 'zing' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: form1.internal_name
      expect( response.body ).not_to have_css 'td', text: form2.internal_name
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
          handler:       'plain_email'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_forms.edit_form_path( ShinyForms::Form.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_forms.admin.forms.create.success' )
    end

    it 'fails when the form is submitted without all the required details' do
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
      form = create :plain_email_form

      get shiny_forms.edit_form_path( form )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
    end
  end

  describe 'PUT /admin/forms/:id' do
    it 'updates the form handler when the appropriate details are submitted' do
      form = create :plain_email_form
      old_name = form.name
      new_name = Faker::Books::CultureSeries.unique.culture_ship

      put shiny_forms.form_path( form ), params: {
        form: {
          internal_name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_forms.edit_form_path( ShinyForms::Form.last )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_forms.admin.forms.update.success' )
      expect( response.body ).to     have_field 'form[internal_name]', with: new_name
      expect( response.body ).not_to have_field 'form[internal_name]', with: old_name
    end

    it 'fails when the form is submitted without all the required details' do
      form = create :plain_email_form

      put shiny_forms.form_path( form ), params: {
        form: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_forms.admin.forms.update.failure' )
    end
  end

  describe 'DELETE /admin/form/:id' do
    it 'deletes the specified form' do
      f1 = create :plain_email_form
      f2 = create :plain_email_form
      f3 = create :plain_email_form

      delete shiny_forms.form_path( f2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_forms.forms_path
      follow_redirect!
      success_message = I18n.t( 'shiny_forms.admin.forms.destroy.success' )
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: success_message
      expect( response.body ).to     have_css 'td', text: f1.name
      expect( response.body ).not_to have_css 'td', text: f2.name
      expect( response.body ).to     have_css 'td', text: f3.name
    end

    it 'fails gracefully when attempting to delete a non-existent form' do
      delete shiny_forms.form_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_forms.forms_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_forms.admin.forms.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_forms.admin.forms.set_form.not_found' )
    end
  end
end
