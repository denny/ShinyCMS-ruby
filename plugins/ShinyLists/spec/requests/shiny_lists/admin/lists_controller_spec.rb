# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyLists::Admin::ListsController, type: :request do
  before do
    admin = create :list_admin
    sign_in admin
  end

  describe 'GET /admin/lists' do
    context 'when there are no mailing lists' do
      it "displays the 'no mailing lists found' message" do
        get shiny_lists.lists_path

        pager_info = 'No mailing lists found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are mailing lists' do
      it 'displays the list of mailing lists' do
        create_list :mailing_list, 3

        get shiny_lists.lists_path

        pager_info = 'Displaying 3 mailing lists'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/lists/search?q=zing' do
    it 'fetches the list of matching mailing lists' do
      list1 = create :mailing_list, slug: 'zingy-zebra'
      list2 = create :mailing_list, slug: 'awesome-aardvark'

      get shiny_lists.search_lists_path, params: { q: 'zing' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: list1.internal_name
      expect( response.body ).not_to have_css 'td', text: list2.internal_name
    end
  end

  describe 'GET /admin/lists/new' do
    it 'loads the page to add a new mailing list' do
      get shiny_lists.new_list_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.new.title' ).titlecase
    end
  end

  describe 'POST /admin/lists' do
    it 'adds a new list when the appropriate details are submitted' do
      post shiny_lists.lists_path, params: {
        list: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.edit_list_path( ShinyLists::List.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_lists.admin.lists.create.success' )
    end

    it 'fails when the list is submitted without all the required details' do
      post shiny_lists.lists_path, params: {
        list: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_lists.admin.lists.create.failure' )
    end
  end

  describe 'GET /admin/lists/:id/edit' do
    it 'loads the page to edit an existing list' do
      list = create :mailing_list

      get shiny_lists.edit_list_path( list )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.edit.title' ).titlecase
    end
  end

  describe 'PUT /admin/lists/:id' do
    it 'updates the list when the appropriate details are submitted' do
      list = create :mailing_list
      old_name = list.name
      new_name = Faker::Books::CultureSeries.unique.culture_ship

      put shiny_lists.list_path( list ), params: {
        list: {
          internal_name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.edit_list_path( ShinyLists::List.last )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_lists.admin.lists.edit.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_lists.admin.lists.update.success' )
      expect( response.body ).to     have_field 'list[internal_name]', with: new_name
      expect( response.body ).not_to have_field 'list[internal_name]', with: old_name
    end

    it 'fails when the list is submitted without all the required details' do
      list = create :mailing_list

      put shiny_lists.list_path( list ), params: {
        list: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.lists.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_lists.admin.lists.update.failure' )
    end
  end

  describe 'DELETE /admin/list/:id' do
    it 'deletes the specified list' do
      list1 = create :mailing_list
      list2 = create :mailing_list
      list3 = create :mailing_list

      delete shiny_lists.list_path( list2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_lists.lists_path
      follow_redirect!
      success_message = I18n.t( 'shiny_lists.admin.lists.destroy.success' )
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_lists.admin.lists.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: success_message
      expect( response.body ).to     have_css 'td', text: list1.name
      expect( response.body ).not_to have_css 'td', text: list2.name
      expect( response.body ).to     have_css 'td', text: list3.name
    end
  end
end
