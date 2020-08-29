# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Main site controller for mailing list subscriptions - part of the ShinyLists plugin for ShinyCMS
  class SubscriptionsController < MainController
    def index
      authenticate_user! unless params[:token]

      if subscriber
        @subscriptions = subscriber.subscriptions
      else
        flash.now[:alert] = t( '.subscriber_not_found' )
      end
    end

    def create
      new_subscription = Subscription.new( list: list, subscriber: subscriber_for_create )

      if new_subscription.save
        redirect_back fallback_location: view_list_subscriptions_path, notice: t( '.success' )
      else
        redirect_back fallback_location: view_list_subscriptions_path, alert: t( '.failure' )
      end
    end

    def unsubscribe
      if subscription.unsubscribe
        redirect_back fallback_location: view_list_subscriptions_path, notice: t( '.success' )
      else
        redirect_back fallback_location: view_list_subscriptions_path, alert: t( '.failure' )
      end
    end

    private

    def list
      List.find_by( slug: params[ :slug ] )
    end

    def subscriber_for_create
      current_user ||
        EmailRecipient.find_by( email: params[:email] ) ||
        EmailRecipient.create!( email: params[:email] )
    end

    def subscriber
      current_user || EmailRecipient.find_by( token: params[:token] )
    end

    def subscription
      subscriber.subscriptions.find_by( list: list )
    end

    def view_list_subscriptions_path
      if user_signed_in?
        user_list_subscriptions_path
      else
        token_list_subscriptions_path( params[:token] )
      end
    end
  end
end
