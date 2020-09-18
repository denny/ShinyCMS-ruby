# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Controller for main site newsletter features - from the ShinyNewsletters plugin for ShinyCMS
  class NewslettersController < MainController
    def index
      authenticate_user! unless params[:token]

      if subscriber
        @recent_sends = newsletters_sent_to_subscribed_lists&.recent&.page( page_number )&.per( items_per_page )
      else
        flash.now[:alert] = t( '.subscriber_not_found' )
      end
    end

    def show
      # TODO: I need to get from MJML to HTML here
      @subscriber = subscriber
      @send = newsletter_sent_to_subscribed_list
      @edition = @send.edition
    end

    private

    def subscriber
      current_user || EmailRecipient.find_by( token: params[:token] )
    end

    def newsletters_sent_to_subscribed_lists
      Send.sent.where( list: subscriber&.lists&.ids )
    end

    def newsletter_sent_to_subscribed_list
      return if newsletters_sent_to_subscribed_lists.blank?

      newsletters_sent_to_subscribed_lists.sent_in_month( params[:year].to_i, params[:month].to_i ).each do |sent|
        return sent if sent.edition.slug == params[:slug]
      end
    end
  end
end
