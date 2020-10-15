# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for job that builds the blog atom feed
module ShinyBlog
  RSpec.describe BuildAtomFeedJob do
    describe '.perform_later' do
      it 'queues the job' do
        expect { BuildAtomFeedJob.perform_later }.to have_enqueued_job
      end
    end

    describe '.perform_now' do
      it 'builds the atom feed' do
        create :long_blog_post

        atom_feed_intro = <<~TOP
          <?xml version="1.0" encoding="UTF-8"?>
          <feed xmlns="http://www.w3.org/2005/Atom"
        TOP

        BuildAtomFeedJob.perform_now

        file_content = File.read Rails.root.join( 'public/feeds/atom/blog.xml' )

        expect( file_content ).to start_with atom_feed_intro
      end
    end
  end
end
