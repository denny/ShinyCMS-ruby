# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Main site controller for mailing list subscriptions - part of the ShinyLists plugin for ShinyCMS
  class SubscriptionsController < MainController
    def index
      authenticate_user! unless params[:token]

      if subscriber
        @subscriptions = subscriber.subscriptions

        flash.now[:alert] = t( '.email_not_confirmed' ) unless subscriber.confirmed?
      else
        flash.now[:alert] = t( '.subscriber_not_found' )
      end
    end

    def subscribe
      if list && consent_version && list.subscribe( subscriber_for_subscribe, consent_version )
        redirect_back fallback_location: view_list_subscriptions_path, notice: subscribe_success_message
      else
        redirect_back fallback_location: main_app.root_path, alert: subscribe_failure_message
      end
    end

    def unsubscribe
      if subscription&.unsubscribe
        redirect_back fallback_location: view_list_subscriptions_path, notice: t( '.success' )
      else
        redirect_back fallback_location: main_app.root_path, alert: t( '.failure' )
      end
    end

    private

    def list
      List.find_by( slug: params[:slug] )
    end

    def subscriber
      current_user || EmailRecipient.find_by( token: token )
    end

    def subscription
      subscriber.subscriptions.find_by( list: list )
    end

    def subscriber_for_subscribe
      current_user ||
        EmailRecipient.find_by( email: subscribe_params[:email] ) ||
        EmailRecipient.create!( email: subscribe_params[:email] )
    end

    def consent_version
      return unless subscribe_params[:consent_confirmation] == '1'

      ConsentVersion.find_by( slug: subscribe_params[:consent_version] )
    end

    def token
      return params[:token] unless action_name == 'subscribe'

      subscriber_for_subscribe&.token
    end

    def subscribe_params
      params.require( :subscription ).permit( :name, :email, :consent_version, :consent_confirmation )
    end

    def view_list_subscriptions_path
      return user_list_subscriptions_path if user_signed_in?

      token_list_subscriptions_path( token )
    end

    def subscribe_success_message
      return t( 'shiny_lists.subscriptions.subscribe.success' ) if subscription.updated_at == subscription.created_at

      t( 'shiny_lists.subscriptions.subscribe.already_subscribed' )
    end

    def subscribe_failure_message
      return t( 'shiny_lists.subscriptions.subscribe.list_not_found'  ) if list.blank?
      return t( 'shiny_lists.subscriptions.subscribe.consent_missing' ) if consent_version.blank?

      t( 'shiny_lists.subscriptions.subscribe.failure' )
    end
  end
end
