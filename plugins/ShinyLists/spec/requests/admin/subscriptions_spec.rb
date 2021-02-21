# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for list subscription admin features
RSpec.describe 'List Subscription admin features', type: :request do
  let( :list ) { create :mailing_list }

  before do
    admin = create :list_admin
    sign_in admin
  end

  describe 'GET /admin/list/:id/subscriptions' do
    it 'displays the list of subscribers for the specified mailing list' do
      create :mailing_list_subscription, list: list
      create :mailing_list_subscription, list: list
      create :mailing_list_subscription, list: list

      get shiny_lists.list_subscriptions_path( list )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
    end
  end

  describe 'GET /admin/list/:id/subscriptions/search?q=2001-12-31' do
    it 'displays the list of matching subscriptions' do
      create :mailing_list_subscription, list: list, subscribed_at: 2.days.ago
      create :mailing_list_subscription, list: list, subscribed_at: 1.day.ago

      get shiny_lists.search_list_subscriptions_path( list ), params: { q: 2.days.ago.strftime( '%F' ) }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: 2.days.ago.to_s( :shinydate_with_day )
    end
  end

  describe 'POST /admin/list/:list_id/subscriptions' do
    it 'subscribes an email address to the specified mailing list' do
      post shiny_lists.list_subscriptions_path( list ), params: {
        subscription: {
          email: Faker::Internet.unique.email
        }
      }

      success_message = I18n.t( 'shiny_lists.admin.subscriptions.create.success' )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.list_subscriptions_path( list )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: success_message
    end
  end

  describe 'DELETE /admin/list/:list_id/subscription/:id' do
    it 'unsubscribes the specified subscriber from the specified mailing list' do
      s1 = create :mailing_list_subscription, list: list

      delete shiny_lists.list_subscription_path( list, s1 )

      success_message = I18n.t( 'shiny_lists.admin.subscriptions.destroy.success' )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.list_subscriptions_path( list )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: success_message
      expect( response.body ).to have_css 'td', text: I18n.t( 'shiny_lists.unsubscribed' )
    end
  end
end
