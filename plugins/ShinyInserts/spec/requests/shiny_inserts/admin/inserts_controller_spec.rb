# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyInserts::Admin::InsertsController, type: :request do
  before do
    admin = create :insert_admin
    sign_in admin
  end

  describe 'GET /admin/inserts' do
    it 'fetches the inserts page in the admin area' do
      get shiny_inserts.inserts_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
    end
  end

  describe 'POST /admin/inserts/create' do
    it 'adds a new Short Text element' do
      post shiny_inserts.create_insert_path, params: {
        insert_element: {
          name:         'new_insert',
          content:      'NEW AND IMPROVED!',
          element_type: 'short_text'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_inserts.admin.inserts.create.success' )
      expect( response.body ).to include 'New insert'
    end

    it 'adds a new element, with an empty content string' do
      post shiny_inserts.create_insert_path, params: {
        'insert_element[name]':         'insert_is_empty',
        'insert_element[content]':      '',
        'insert_element[element_type]': 'short_text'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_inserts.admin.inserts.create.success' )
      expect( response.body ).to include 'Insert is empty'
    end

    it 'adds a new element, with a NULL content string' do
      post shiny_inserts.create_insert_path, params: {
        'insert_element[name]':         'insert_is_null',
        'insert_element[content]':      nil,
        'insert_element[element_type]': 'short_text'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_inserts.admin.inserts.create.success' )
      expect( response.body ).to include 'Insert is null'
    end

    it 'attempting to add a new insert element with no name fails gracefully' do
      post shiny_inserts.create_insert_path, params: {
        'insert_element[content]': 'MADE OF FAIL!'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_inserts.admin.inserts.create.failure' )
    end
  end

  describe 'DELETE /admin/inserts/delete/:id' do
    it 'deletes the specified insert' do
      s1 = create :insert_element
      s2 = create :insert_element, name: 'do_not_want'
      s3 = create :insert_element

      delete shiny_inserts.destroy_insert_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_inserts.admin.inserts.destroy.success' )
      expect( response.body ).to     include s1.name.humanize
      expect( response.body ).to     include s3.name.humanize
      expect( response.body ).not_to include 'do_not_want'
      expect( response.body ).not_to include 'Do not want'
    end

    it 'fails gracefully when attempting to delete non-existent insert' do
      delete shiny_inserts.destroy_insert_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_inserts.admin.inserts.destroy.failure' )
    end
  end

  describe 'POST /admin/inserts' do
    it 'updates any insert that was changed' do
      create :insert_element
      s2 = create :insert_element, content: 'Original content'
      create :insert_element

      # The [1] here means 'the second item on the form'; it's not the db row id
      put shiny_inserts.inserts_path, params: {
        'insert_set[elements_attributes][1][id]':           s2.id,
        'insert_set[elements_attributes][1][name]':         s2.name,
        'insert_set[elements_attributes][1][content]':      'Updated content',
        'insert_set[elements_attributes][1][element_type]': s2.element_type
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_inserts.admin.inserts.update.success' )
      expect( response.body ).not_to include 'Original content'
      expect( response.body ).to     include 'Updated content'
    end

    it 'shows an error message if insert names collide' do
      s1 = create :insert_element
      s2 = create :insert_element, content: 'Original content'
      create :insert_element

      # The [1] here means 'the second item on the form'; it's not the db row id
      put shiny_inserts.inserts_path, params: {
        'insert_set[elements_attributes][1][id]':           s2.id,
        'insert_set[elements_attributes][1][name]':         s1.name,
        'insert_set[elements_attributes][1][content]':      'Updated content',
        'insert_set[elements_attributes][1][element_type]': s2.element_type
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_inserts.inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_inserts.admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger',
                                              text: I18n.t( 'shiny_inserts.admin.inserts.update.failure' )
      expect( response.body ).to     include 'Original content'
      expect( response.body ).not_to include 'Updated content'
    end
  end
end
