# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Send an edition of a newsletter to an individual subscriber on a list
  class SendToSubscriberJob < ApplicationJob
    def perform( send, subscriber )
      return if send.sent?

      return unless send.list.subscribed? subscriber.email

      NewsletterMailer.send_email( send.edition, subscriber ).deliver
    end
  end
end
