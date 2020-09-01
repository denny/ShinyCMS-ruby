# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for list subscription admin features
RSpec.describe 'List Subscription admin features', type: :request do
  let( :list ) { create :mailing_list }

  before :each do
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

  describe 'POST /admin/list/:list_id/subscriptions' do
    it 'subscribes an email address to the specified mailing list' do
      post shiny_lists.list_subscriptions_path( list ), params: {
        subscription: {
          email: Faker::Internet.unique.email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.list_subscriptions_path( list )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/list/:list_id/subscription/:id' do
    it 'unsubscribes the specified subscriber from the specified mailing list' do
      s1 = create :mailing_list_subscription, list: list

      put shiny_lists.list_subscription_path( list, s1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.list_subscriptions_path( list )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: I18n.t( 'shiny_lists.unsubscribed' )
    end
  end

  describe 'DELETE /admin/list/:id/subscription/:subscription_id' do
    it 'deletes the specified subscription' do
      subscription1 = create :mailing_list_subscription, list: list
      subscription2 = create :mailing_list_subscription, list: list
      subscription3 = create :mailing_list_subscription, list: list

      delete shiny_lists.list_subscription_path( list, subscription2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_lists.list_subscriptions_path( list )
      follow_redirect!
      success_message = I18n.t( 'shiny_lists.admin.subscriptions.destroy.success' )
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_lists.admin.subscriptions.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: success_message
      expect( response.body ).to     have_css 'td', text: subscription1.subscriber.email
      expect( response.body ).not_to have_css 'td', text: subscription2.subscriber.email
      expect( response.body ).to     have_css 'td', text: subscription3.subscriber.email
    end
  end
end
