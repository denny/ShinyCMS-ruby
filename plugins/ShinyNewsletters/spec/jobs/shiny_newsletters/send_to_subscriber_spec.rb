# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that sends a single copy of a newsletter edition to a subscriber
module ShinyNewsletters
  RSpec.describe SendToSubscriberJob do
    describe '.perform_later' do
      it 'queues a send-to-subscriber job' do
        subscriber1 = create :email_recipient, :confirmed
        send1       = create :newsletter_send
        consent1    = create :consent_version

        send1.list.subscribe( subscriber1, consent1 )

        expect { SendToSubscriberJob.perform_later( send1, subscriber1 ) }.to have_enqueued_job
      end
    end

    describe '.perform_now' do
      it 'with a valid send and subscriber' do
        subscriber1 = create :email_recipient, :confirmed
        send1       = create :newsletter_send
        consent1    = create :consent_version

        send1.list.subscribe( subscriber1, consent1 )

        result = SendToSubscriberJob.perform_now( send1, subscriber1 )

        expect( result ).to be_a Mail::Message
      end

      context 'with an already-sent Send' do
        it 'bails out before sending' do
          subscriber1 = create :email_recipient, :confirmed
          send1       = create :newsletter_send_sent

          expect( SendToSubscriberJob.perform_now( send1, subscriber1 ) ).to be_nil
        end
      end
    end
  end
end
