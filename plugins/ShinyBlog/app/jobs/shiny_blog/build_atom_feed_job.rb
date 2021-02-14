# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Background job to regenerate blog Atom feed - part of the ShinyBlog plugin for ShinyCMS
  # Called when a blog post is added or updated (TODO: or when a future-dated post goes live)
  class BuildAtomFeedJob < ApplicationJob
    include Sidekiq::Status::Worker

    def perform
      posts = Post.recent.limit( 10 )

      atom_feed = ShinyCMS::ShinyPostAtomFeed.new( :blog )

      atom_feed.build( posts )

      atom_feed.write_file
    end
  end
end
