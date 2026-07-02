# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Background job to regenerate news section Atom feed - part of the ShinyNews plugin for ShinyCMS
  # Called when a news post is added or updated (TODO: or when a future-dated post goes live)
  class BuildAtomFeedJob < ApplicationJob
    include Sidekiq::Status::Worker

    def perform
      posts = Post.recent.limit( 10 )

      ShinyCMS::AtomFeedBuilder.call( :news, posts )
    end
  end
end
