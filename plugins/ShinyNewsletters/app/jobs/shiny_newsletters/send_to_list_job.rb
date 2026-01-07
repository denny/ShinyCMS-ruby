# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Job to check for sends that are ready to go, and get them going :)
  class SendToListJob < ApplicationJob
    include Sidekiq::Status::Worker

    def perform( send )
      return unless send.sendable?

      send.mark_as_sending

      send.list.subscriptions.each do |subscription|
        next unless subscription.subscriber.ok_to_email?

        SendToSubscriberJob.perform_later( send, subscription.subscriber )
      end

      send.mark_as_sent
    end
  end
end
