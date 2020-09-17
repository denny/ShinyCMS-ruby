# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Controller for list subscription admin features - part of the ShinyLists plugin for ShinyCMS
  class Admin::SubscriptionsController < AdminController
    def index
      authorise Subscription

      return if list.subscriptions.blank?

      page_num = params[:page] || 1
      # TODO: How do I order this by subscriber.email ?
      @subscriptions = list.subscriptions.order( Arel.sql( 'unsubscribed_at is null' ) ).page( page_num )

      authorise @subscriptions
    end

    # NB: If you live in GDPR territory, before using this feature you should consider whether
    # you could prove that the person actively consented to be subscribed to your mailing list.
    def subscribe
      authorise Subscription

      flash[:notice] = t( '.success' ) if list.subscribe( subscriber_for_subscribe, admin_consent )

      redirect_to list_subscriptions_path( list )
    end

    def unsubscribe
      authorise subscription

      flash[:notice] = t( '.success' ) if subscription.unsubscribe

      redirect_to list_subscriptions_path( list )
    end

    # Override the breadcrumbs 'section' link to go back to the lists page
    def breadcrumb_link_text_and_path
      [ t( 'shiny_lists.admin.lists.title' ), lists_path ]
    end

    private

    def list
      ShinyLists::List.find( params[:list_id] )
    end

    def subscription
      list.subscriptions.find( params[:id] )
    end

    def subscriber_for_subscribe
      User.find_by( email: subscription_params[:email] ) ||
        EmailRecipient.find_by( email: subscription_params[:email] ) ||
        EmailRecipient.create!( email: subscription_params[:email] )
    end

    def admin_consent
      ConsentVersion.find_by( slug: 'shiny-lists-admin-subscribe' )
    end

    def subscription_params
      params.require( :subscription ).permit( :email, :page, :count )
    end
  end
end
