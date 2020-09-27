# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for consent version admin features
RSpec.describe Admin::ConsentVersionsController, type: :request do
  before :each do
    admin = create :consent_admin
    sign_in admin
  end

  describe 'GET /admin/consent-versions' do
    it 'fetches the list of consent versions' do
      version = create :consent_version

      get consent_versions_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: version.name
    end
  end

  describe 'GET /admin/consent-version/1' do
    it 'displays the details of an in-use consent version' do
      version1 = create :consent_version

      get consent_version_path( version1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.show.title' ).titlecase
      expect( response.body ).to have_css 'p', text: version1.name
    end
  end

  describe 'GET /admin/consent-version/new' do
    it 'loads the form to add a new consent version' do
      get new_consent_version_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.new.title' ).titlecase
    end
  end

  describe 'POST /admin/consent-versions' do
    it 'fails when the form is submitted without all the details' do
      post consent_versions_path, params: {
        consent_version: {
          name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.consent_versions.create.failure' )
    end

    it 'adds a new consent version when the form is filled in correctly' do
      post consent_versions_path, params: {
        consent_version: {
          name: Faker::Books::CultureSeries.unique.culture_ship,
          display_text: Faker::Lorem.paragraph
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_consent_version_path( ConsentVersion.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.consent_versions.create.success' )
    end
  end

  describe 'GET /admin/consent-versions/:id' do
    it 'loads the form to edit an existing consent version' do
      version = create :consent_version

      get edit_consent_version_path( version )

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.consent_versions.edit.title' ).titlecase
      expect( response.body ).not_to have_css 'th', text: I18n.t( 'capability.capabilities' )
    end
  end

  describe 'POST /admin/consent-versions/:id' do
    it 'fails to update the consent version when submitted with blank display text' do
      version = create :consent_version

      put consent_version_path( version ), params: {
        consent_version: {
          display_text: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.consent_versions.update.failure' )
    end

    it 'raises an error if the consent version has already been agreed to by some people' do
      version1 = create :consent_version
      create :mailing_list_subscription, consent_version: version1

      expect { put consent_version_path( version1 ), params: { consent_version: { slug: 'new-slug' } } }
        .to raise_error ConsentVersion::HasBeenAgreedTo
    end

    it 'updates the consent version when the form is submitted' do
      version = create :consent_version

      put consent_version_path( version ), params: {
        consent_version: {
          slug: 'new-slug'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_consent_version_path( version )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.consent_versions.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.consent_versions.update.success' )
      expect( response.body ).to have_field 'consent_version[slug]', with: 'new-slug'
    end
  end

  describe 'DELETE /admin/consent-versions/:id' do
    it 'deletes the specified consent version' do
      version1 = create :consent_version
      version2 = create :consent_version
      version3 = create :consent_version

      delete consent_version_path( version2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to consent_versions_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.consent_versions.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.consent_versions.destroy.success' )
      expect( response.body ).to     have_css 'td', text: version1.name
      expect( response.body ).not_to have_css 'td', text: version2.name
      expect( response.body ).to     have_css 'td', text: version3.name
    end

    it 'raises an error if the consent version has already been agreed to by some people' do
      version1 = create :consent_version
      create :mailing_list_subscription, consent_version: version1

      expect { delete consent_version_path( version1 ) }.to raise_error ConsentVersion::HasBeenAgreedTo
    end
  end
end
