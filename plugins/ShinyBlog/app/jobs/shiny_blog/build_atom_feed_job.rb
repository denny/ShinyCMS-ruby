# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Background job to regenerate blog Atom feed - part of the ShinyBlog plugin for ShinyCMS
  # Called when a blog post is added or updated (TODO: or when a future-dated post goes live)
  class BuildAtomFeedJob < ApplicationJob
    include ShinyPostAdmin

    include Rails.application.routes.url_helpers

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end

    def perform
      posts = Post.recent.limit( 10 )

      feed = build_feed( 'blog', posts )

      write_feed( 'blog', feed )
    end
  end
end
