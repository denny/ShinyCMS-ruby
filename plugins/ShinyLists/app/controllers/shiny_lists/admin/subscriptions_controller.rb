# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Controller for list subscription admin features - part of the ShinyLists plugin for ShinyCMS
  class Admin::SubscriptionsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::WithConsentVersion
    include ShinyCMS::WithEmailRecipients
    include ShinyCMS::WithUsers

    def index
      authorize Subscription

      return if list.subscriptions.blank?

      # TODO: How do I order this by subscriber.email ?
      @pagy, @subscriptions = pagy(
        list.subscriptions.recent.order( Arel.sql( 'unsubscribed_at is null' ) )
      )

      authorize @subscriptions
    end

    def search
      authorize Subscription

      search_term = params[:q]

      @pagy, @subscriptions = pagy(
        subscriptions.where( 'date(subscribed_at) = ?', search_term )
                     .or( subscriptions.where( 'date(unsubscribed_at) = ?', search_term ) )
                     .order( subscribed_at: :desc )
      )

      authorize @subscriptions if @subscriptions.present?
      render :index
    end

    # NB: If you live in GDPR territory, before using this feature you should consider whether
    # you could prove that the person actively consented to be subscribed to your mailing list.
    def create
      authorize Subscription

      flash[:notice] = t( '.success' ) if list.subscribe( subscriber_for_subscribe, admin_consent )

      redirect_to list_subscriptions_path( list )
    end

    def destroy
      authorize subscription

      flash[:notice] = t( '.success' ) if subscription.unsubscribe

      redirect_to list_subscriptions_path( list )
    end

    def breadcrumb_section_path
      shiny_lists.lists_path
    end

    private

    def list
      ShinyLists::List.find( params[:list_id] )
    end

    def subscriptions
      list.subscriptions
    end

    def subscription
      subscriptions.find( params[:id] )
    end

    def subscriber_for_subscribe
      user_with_email( subscription_params[:email] ) ||
        email_recipient_with_email( subscription_params[:email] ) ||
        create_email_recipient( subscription_params[:email] )
    end

    def admin_consent
      consent_version_with_slug( 'shiny-lists-admin-subscribe' )
    end

    def subscription_params
      params.expect( subscription: %i[ email page count ] )
    end
  end
end
