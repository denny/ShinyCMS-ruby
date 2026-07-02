# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyAccess::Admin::GroupsController, type: :request do
  before do
    admin = create :access_admin
    sign_in admin
  end

  describe 'GET /admin/access/groups' do
    context 'when there are no groups' do
      it "displays the 'no groups found' message" do
        get shiny_access.groups_path

        pager_info = 'No access groups found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are some groups' do
      it 'displays the list of access groups' do
        create_list :access_group, 3

        get shiny_access.groups_path

        pager_info = 'Displaying 3 access groups'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/access/groups/search?q=zing' do
    it 'displays the list of matching access groups' do
      group1 = create :access_group, slug: 'zingy-zebra'
      group2 = create :access_group, slug: 'awesome-aardvark'

      get shiny_access.search_groups_path, params: { q: 'zing' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: group1.internal_name
      expect( response.body ).not_to have_css 'td', text: group2.internal_name
    end
  end

  describe 'GET /admin/access/groups/new' do
    it 'loads the page to add a new access group' do
      get shiny_access.new_group_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.new.title' ).titlecase
    end
  end

  describe 'POST /admin/access/groups' do
    it 'adds a new group when the appropriate details are submitted' do
      post shiny_access.groups_path, params: {
        group: {
          internal_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.edit_group_path( ShinyAccess::Group.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_access.admin.groups.create.success' )
    end

    it 'fails when the group is submitted without all the required details' do
      post shiny_access.groups_path, params: {
        group: {
          public_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_access.admin.groups.create.failure' )
    end
  end

  describe 'GET /admin/access/groups/:id/edit' do
    it 'loads the page to edit an existing group' do
      group = create :access_group

      get shiny_access.edit_group_path( group )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.edit.title' ).titlecase
    end
  end

  describe 'PUT /admin/access/groups/:id' do
    it 'updates the group when the appropriate details are submitted' do
      group = create :access_group
      old_name = group.name
      new_name = Faker::Books::CultureSeries.unique.culture_ship

      put shiny_access.group_path( group ), params: {
        group: {
          internal_name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.edit_group_path( ShinyAccess::Group.last )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_access.admin.groups.edit.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_access.admin.groups.update.success' )
      expect( response.body ).to     have_field 'group[internal_name]', with: new_name
      expect( response.body ).not_to have_field 'group[internal_name]', with: old_name
    end

    it 'fails when the group is submitted without all the required details' do
      group = create :access_group

      put shiny_access.group_path( group ), params: {
        group: {
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.groups.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_access.admin.groups.update.failure' )
    end
  end

  describe 'DELETE /admin/group/:id' do
    it 'deletes the specified group' do
      group1 = create :access_group
      group2 = create :access_group
      group3 = create :access_group

      delete shiny_access.group_path( group2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_access.groups_path
      follow_redirect!
      success_message = I18n.t( 'shiny_access.admin.groups.destroy.success' )
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_access.admin.groups.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: success_message
      expect( response.body ).to     have_css 'td', text: group1.name
      expect( response.body ).not_to have_css 'td', text: group2.name
      expect( response.body ).to     have_css 'td', text: group3.name
    end
  end
end
