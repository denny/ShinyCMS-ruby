# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Job to check for sends that are ready to go, and get them going :)
  class SendToListJob < ApplicationJob
    include Sidekiq::Status::Worker

    def perform( send )
      return if send.sent?
      return if send.sending?
      return if send.future_dated?

      send.update!( started_sending_at: Time.zone.now )

      send.list.subscriptions.each do |subscription|
        next if subscription.subscriber.do_not_email?

        SendToSubscriberJob.perform_later( send, subscription.subscriber )
      end

      send.update!( finished_sending_at: Time.zone.now )
    end
  end
end
