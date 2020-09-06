# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site list subscription features
RSpec.describe 'List subscriptions', type: :request do
  before do
    FeatureFlag.enable :mailing_lists
    FeatureFlag.enable :user_login
  end

  describe 'GET /subscriptions' do
    it "displays a logged-in user's subscriptions" do
      user1 = create :user
      sign_in user1

      get shiny_lists.user_list_subscriptions_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
    end

    it 'prompts a not-logged-in user to log in' do
      get shiny_lists.user_list_subscriptions_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to main_app.new_user_session_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'devise.failure.unauthenticated' )
    end
  end

  describe 'GET /subscriptions/:token' do
    it "displays a token-identified user's subscriptions" do
      subscriber1 = create :email_recipient

      get shiny_lists.token_list_subscriptions_path( subscriber1.token )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
    end

    it 'displays an error message for a non-existent token' do
      get shiny_lists.token_list_subscriptions_path( 'non-existent-token' )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_lists.subscriptions.index.subscriber_not_found' )
    end
  end

  describe 'POST /list/:slug/subscribe' do
    it 'creates a new subscription for a logged-in user' do
      list1 = create :mailing_list
      consent1 = create :consent_version
      user1 = create :user
      sign_in user1

      post shiny_lists.list_subscribe_path( list1.slug ), params: {
        subscription: {
          consent_version: consent1.slug,
          consent_confirmation: '1'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.user_list_subscriptions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_lists.subscriptions.subscribe.success' )
    end

    it 'fails to create a new subscription to a non-existent list' do
      user1 = create :user
      consent1 = create :consent_version
      sign_in user1

      post shiny_lists.list_subscribe_path( 'no-such-list' ), params: { consent_version: consent1.slug }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.user_list_subscriptions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_lists.subscriptions.subscribe.failure' )
    end
  end

  describe 'PUT /list/:slug/unsubscribe' do
    it 'unsubscribes a logged-in user' do
      list1 = create :mailing_list
      user1 = create :user
      create :mailing_list_subscription, list: list1, subscriber: user1
      sign_in user1

      put shiny_lists.user_list_unsubscribe_path( list1.slug )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.user_list_subscriptions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_lists.subscriptions.unsubscribe.success' )
    end

    it 'fails to unsubscribe a logged-in user from a non-existent list' do
      user1 = create :user
      sign_in user1

      put shiny_lists.user_list_unsubscribe_path( 'non-existent-list' )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.user_list_subscriptions_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_lists.subscriptions.unsubscribe.failure' )
    end
  end

  describe 'PUT /list/:slug/unsubscribe/:token' do
    it 'unsubscribes a token-authenticated user' do
      list1 = create :mailing_list
      subscriber1 = create :email_recipient
      create :mailing_list_subscription, list: list1, subscriber: subscriber1

      put shiny_lists.token_list_unsubscribe_path( list1.slug, subscriber1.token )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_lists.token_list_subscriptions_path( subscriber1.token )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_lists.subscriptions.index.title' )
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shiny_lists.subscriptions.unsubscribe.success' )
    end
  end
end
