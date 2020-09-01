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
      authorise list
      authorise Subscription

      page_num = params[:page] || 1
      @subscriptions = list.subscriptions&.page( page_num )

      authorise @subscriptions if @subscriptions.present?
    end

    def create
      authorise Subscription

      # TODO: find/create subscriber (user/email recipient)
      subscriber = EmailRecipient.create!( email: subscription_params[:email] )

      new_subscription = ShinyLists::Subscription.new( list: list, subscriber: subscriber )

      if new_subscription.save
        redirect_to list_subscriptions_path( list ), notice: t( '.success' )
      else
        redirect_to list_subscriptions_path( list ), alert: t( '.failure' )
      end
    end

    def update
      # Unsubscribe
      authorise subscription

      if subscription.unsubscribe
        redirect_to list_subscriptions_path, notice: t( '.success' )
      else
        redirect_to list_subscriptions_path, alert: t( '.failure' )
      end
    end

    def destroy
      authorise subscription

      flash[ :notice ] = t( '.success' ) if subscription.destroy
      redirect_to list_subscriptions_path
    end

    private

    def list
      ShinyLists::List.find( params[:list_id] )
    end

    def subscription
      list.subscriptions.find( params[:id] )
    end

    def subscription_params
      params.require( :subscription ).permit( :email )
    end
  end
end
