# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyAccess::Admin::MembershipsController, type: :request do
  before do
    admin = create :access_admin
    sign_in admin
  end

  let( :group1 ) { create :access_group }

  describe 'GET /admin/access/groups/1/memberships' do
    it "displays the 'no items found' message" do
      get shiny_access.group_memberships_path( group1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css 'p', text: 'No access group memberships found'
    end

    it 'displays the list of access group memberships' do
      item1 = create :access_membership, group: group1
      create :access_membership, group: group1

      get shiny_access.group_memberships_path( group1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css 'td', text: item1.user.username
    end
  end

  describe 'GET /admin/access/groups/1/memberships/search?q={date/dates}' do
    it 'displays the list of matching memberships for a single date' do
      member1 = create :access_membership, group: group1, began_at: 2.days.ago
      member2 = create :access_membership, group: group1

      get shiny_access.search_group_memberships_path( group1 ), params: { q: member1.began_at.iso8601 }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase

      expect( response.body ).to     have_css 'td', text: member1.user.username
      expect( response.body ).not_to have_css 'td', text: member2.user.username
    end

    it 'displays the list of matching memberships for a date range' do
      member1 = create :access_membership, group: group1, began_at: 3.days.ago
      member2 = create :access_membership, group: group1

      date1 = 4.days.ago.to_date.iso8601
      date2 = 2.days.ago.to_date.iso8601

      date_range = "#{date1} to #{date2}"

      get shiny_access.search_group_memberships_path( group1 ), params: { q: date_range }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase

      expect( response.body ).to     have_css 'td', text: member1.user.username
      expect( response.body ).not_to have_css 'td', text: member2.user.username
    end
  end

  describe 'POST /admin/access/groups/1/memberships' do
    it 'creates a new group membership with valid details' do
      user1 = create :user

      post shiny_access.group_memberships_path( group1 ), params: { membership: { user_id: user1.id } }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.group_memberships_path( group1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_access.admin.memberships.create.success' )
    end

    it 'fails to create a new membership with invalid details' do
      post shiny_access.group_memberships_path( group1 ), params: { membership: { user_id: nil } }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.group_memberships_path( group1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_access.admin.memberships.create.failure' )
    end
  end

  describe 'DELETE /admin/groups/1/memberships/:id' do
    it 'marks the membership as ended' do
      membership1 = create :access_membership, group: group1

      delete shiny_access.group_membership_path( group1, membership1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.group_memberships_path( group1 )
      follow_redirect!
      success_message = I18n.t( 'shiny_access.admin.memberships.destroy.success' )
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css '.alert-success', text: success_message

      expect( membership1.reload.ended_at ).not_to be_nil
    end

    it 'refuses to mark an already ended membership as ending today' do
      membership1 = create :access_membership, :ended, group: group1

      delete shiny_access.group_membership_path( group1, membership1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_access.group_memberships_path( group1 )
      follow_redirect!
      failure_message = I18n.t( 'shiny_access.admin.memberships.destroy.failure' )
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_access.admin.memberships.index.title', name: group1.internal_name ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: failure_message
    end
  end
end
