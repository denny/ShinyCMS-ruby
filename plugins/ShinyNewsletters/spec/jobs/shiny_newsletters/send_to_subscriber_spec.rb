# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that sends a single copy of a newsletter edition to a subscriber
RSpec.describe ShinyNewsletters::SendToSubscriberJob do
  before do
    ShinyCMS::FeatureFlag.enable :send_emails
  end

  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  describe '.perform_later' do
    it 'queues a send-to-subscriber job' do
      subscriber1 = create :email_recipient, :confirmed
      send1       = create :newsletter_send
      consent1    = create :consent_version

      send1.list.subscribe( subscriber1, consent1 )

      expect { described_class.perform_later( send1, subscriber1 ) }.to have_enqueued_job
    end
  end

  describe '.perform_now' do
    context 'with a valid send and subscriber' do
      it 'builds an email for delivery' do
        subscriber1 = create :email_recipient, :confirmed
        send1       = create :newsletter_send
        consent1    = create :consent_version

        send1.list.subscribe( subscriber1, consent1 )

        result = described_class.perform_now( send1, subscriber1 )

        expect( result ).to be_a Mail::Message

        expect( result.perform_deliveries ).to be true
      end
    end

    context 'with a valid send and an unconfirmed subscriber' do
      it 'does build an email, but it is not deliverable' do
        subscriber1 = create :email_recipient
        send1       = create :newsletter_send
        consent1    = create :consent_version

        send1.list.subscribe( subscriber1, consent1 )

        result = described_class.perform_now( send1, subscriber1 )

        expect( result ).to be_a Mail::Message

        expect( result.perform_deliveries ).to be false
      end
    end

    context 'with a valid send and a non-subscriber' do
      it 'does not build an email for delivery' do
        subscriber1 = create :email_recipient, :confirmed
        send1       = create :newsletter_send

        result = described_class.perform_now( send1, subscriber1 )

        expect( result ).to be_nil
      end
    end

    context 'with an already-sent Send and a valid subscriber' do
      it 'does not build an email for delivery' do
        subscriber1 = create :email_recipient, :confirmed
        send1       = create :newsletter_send_sent
        consent1    = create :consent_version

        send1.list.subscribe( subscriber1, consent1 )

        result = described_class.perform_now( send1, subscriber1 )

        expect( result ).to be_nil
      end
    end
  end
end
