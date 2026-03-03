# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for viewing email stats in ShinyCMS admin area
  class Admin::EmailStatsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def index
      authorize Ahoy::Message

      messages = ahoy_messages
      messages = messages_to_user      if params[ :user_id ]
      messages = messages_to_recipient if params[ :recipient_id ]

      @pagy, @messages = pagy( messages )

      authorize @messages if @messages.present?
    end

    def search
      authorize Ahoy::Message

      search_term = params[:q]

      @pagy, @messages = pagy(
        Ahoy::Message.where( 'mailer ilike ?', "%#{search_term}%" )
                    .or( Ahoy::Message.where( 'subject ilike ?', "%#{search_term}%" ) )
                    .order( sent_at: :desc )
      )

      authorize @messages if @messages.present?
      render :index
    end

    private

    def ahoy_messages
      Ahoy::Message.order( sent_at: :desc )
    end

    def messages_to_user
      ahoy_messages.where( user: user )
    end

    def messages_to_recipient
      ahoy_messages.where( user: email_recipient )
    end

    def user
      User.find( params[ :user_id ] )
    end

    def email_recipient
      EmailRecipient.find( params[ :recipient_id ] )
    end
  end
end
