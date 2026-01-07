# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that (queues the jobs that) sends a copy of a newsletter edition to everybody on a mailing list
RSpec.describe ShinyNewsletters::SendToListJob do
  before do
    ShinyCMS::FeatureFlag.enable :send_emails
  end

  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  describe '.perform_now' do
    it 'runs the send-to-list job' do
      list1 = create :mailing_list, subscriber_count: 1
      send1 = create :newsletter_send, list: list1

      described_class.perform_now( send1 )

      expect( send1.sent? ).to be true
    end
  end

  describe '.perform_later' do
    it 'queues a send-to-list job' do
      send1 = create :newsletter_send

      expect { described_class.perform_later( send1 ) }.to have_enqueued_job
    end
  end
end
