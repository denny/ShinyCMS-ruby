# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter edition admin features

RSpec.describe 'Admin: Newsletter Editions', type: :request do
  i18n_root = 'shiny_newsletters.admin.editions'

  before :each do
    admin = create :newsletter_admin
    sign_in admin
  end

  describe 'GET /admin/newsletters/editions' do
    it 'fetches the list of editions in the admin area' do
      edition1 = create :newsletter_edition

      get shiny_newsletters.editions_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to have_css 'td', text: edition1.internal_name
    end

    it 'sets page size and page number correctly if overridden' do
      edition1 = create :newsletter_edition
      edition2 = create :newsletter_edition

      get shiny_newsletters.editions_path, params: { page: 2, count: 1 }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to have_css 'td', text: edition2.internal_name
      expect( response.body ).not_to have_css 'td', text: edition1.internal_name
    end
  end

  describe 'GET /admin/newsletters/editions/new' do
    it 'loads the form to add a new edition' do
      get shiny_newsletters.new_edition_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.new.title" ).titlecase
    end
  end

  describe 'POST /admin/newsletters/editions' do
    it 'adds a new edition when the form is submitted' do
      template1 = create :newsletter_template

      post shiny_newsletters.editions_path, params: {
        edition: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id: template1.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_edition_path( ShinyNewsletters::Edition.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( "#{i18n_root}.create.success" )
    end

    it 'fails when the form is submitted without all the details' do
      post shiny_newsletters.editions_path, params: {
        edition: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.new.title" ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( "#{i18n_root}.create.failure" )
    end

    it "fails to create a new edition when the slug isn't unique this month" do
      template1 = create :newsletter_template
      edition1 = create :newsletter_edition, created_at: Time.zone.now.beginning_of_month, updated_at: Time.zone.now.beginning_of_month

      post shiny_newsletters.editions_path, params: {
        edition: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id: template1.id,
          slug: edition1.slug
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.new.title" ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( "#{i18n_root}.create.failure" )
    end

    it 'adds a new edition with elements from template' do
      template1 = create :newsletter_template

      post shiny_newsletters.editions_path, params: {
        edition: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship,
          template_id: template1.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_edition_path( ShinyNewsletters::Edition.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( "#{i18n_root}.create.success" )
      expect( response.body ).to include template1.elements.first.name
      expect( response.body ).to include template1.elements.last.name
    end
  end

  describe 'GET /admin/newsletters/editions/:id' do
    it 'loads the form to edit an existing edition' do
      edition1 = create :newsletter_edition

      get shiny_newsletters.edit_edition_path( edition1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
    end
  end

  describe 'PUT /admin/newsletters/editions/:id' do
    it 'fails to update the edition when submitted with a blank name' do
      edition1 = create :newsletter_edition

      put shiny_newsletters.edition_path( edition1 ), params: {
        edition: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( "#{i18n_root}.update.failure" )
    end

    it 'updates the edition when the form is submitted' do
      edition1 = create :newsletter_edition

      put shiny_newsletters.edition_path( edition1 ), params: {
        edition: {
          internal_name: 'Updated by test'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_edition_path( edition1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( "#{i18n_root}.update.success" )
      expect( response.body ).to have_field 'edition_internal_name', with: 'Updated by test'
    end

    it 'recreates the slug if it is wiped before submitting an update' do
      edition = create :newsletter_edition
      old_slug = edition.slug

      put shiny_newsletters.edition_path( edition ), params: {
        edition: {
          internal_name: 'Updated by test',
          slug: ''
        }
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_newsletters.edit_edition_path( edition )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( "#{i18n_root}.edit.title" ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( "#{i18n_root}.update.success" )
      expect( response.body ).to     have_field 'edition_slug', with: 'updated-by-test'
      expect( response.body ).not_to have_field 'edition_slug', with: old_slug
    end
  end

  describe 'GET /admin/newsletters/editions/:id/send-sample' do
    it 'attempts to send a sample email to the logged-in user' do
      send_admin = create :newsletter_send_admin
      sign_in send_admin

      edition1 = create :newsletter_edition

      get shiny_newsletters.send_sample_path( edition1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.editions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( "#{i18n_root}.send_sample.success" )
    end

    it 'attempts to send a sample email with an invalid MJML template' do
      send_admin = create :newsletter_send_admin
      sign_in send_admin

      invalid1 = create :invalid_newsletter_template
      edition1 = create :newsletter_edition, template: invalid1

      get shiny_newsletters.send_sample_path( edition1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.editions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( "#{i18n_root}.send_sample.mjml_error" )
    end
  end

  describe 'DELETE /admin/newsletters/editions/:id' do
    it 'deletes the specified edition' do
      p1 = create :newsletter_edition
      p2 = create :newsletter_edition
      p3 = create :newsletter_edition

      delete shiny_newsletters.edition_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_newsletters.editions_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( "#{i18n_root}.destroy.success" )
      expect( response.body ).to     have_css 'td', text: p1.internal_name
      expect( response.body ).not_to have_css 'td', text: p2.internal_name
      expect( response.body ).to     have_css 'td', text: p3.internal_name
    end

    it 'fails gracefully when attempting to delete a non-existent edition' do
      delete shiny_newsletters.edition_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.editions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( "#{i18n_root}.index.title" ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( "#{i18n_root}.destroy.failure" )
    end
  end
end
