# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that builds the news post atom feed
RSpec.describe ShinyNews::BuildAtomFeedJob do
  describe '.perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job
    end
  end

  describe '.perform_now' do
    it 'builds the atom feed' do
      create :long_news_post, posted_at: 1.hour.ago
      create :news_post, posted_at: 1.minute.ago
      create :news_post

      atom_feed_intro = <<~TOP
        <?xml version="1.0" encoding="UTF-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom"
      TOP

      described_class.perform_now

      file_content = Rails.public_path.join( 'feeds/atom/news.xml' ).read

      expect( file_content ).to start_with atom_feed_intro
    end
  end
end
