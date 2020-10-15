# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

module ShinyBlog
  # Background job to regenerate blog Atom feed - part of the ShinyBlog plugin for ShinyCMS
  # Called when a new (visible) post is added (TODO: or when a future-dated post goes live)
  class AtomFeedJob < ApplicationJob
    include ShinySiteNameHelper

    include ShinyBlog::MainSiteHelper

    include Rails.application.routes.url_helpers

    FILE_PATH = Rails.root.join( 'public/feeds/atom/blog.xml' ).to_s
    public_constant :FILE_PATH

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end

    def perform
      posts = recent_blog_posts( 10 )

      feed = build_feed( posts )

      File.open FILE_PATH, 'w' do |f|
        f.write feed.to_s
        f.write "\n"
      end
    end

    private

    def build_feed( posts )
      RSS::Maker.make( 'atom' ) do |maker|
        add_channel_info( maker, posts.first.posted_at )

        posts.each do |post|
          add_post( maker, post )
        end
      end
    end

    def add_channel_info( maker, most_recent_posted_at )
      maker.channel.about   = "#{base_url}/feeds/atom/blog.xml"
      maker.channel.author  = Setting.get( :blog_feed_author ) || site_name
      maker.channel.title   = Setting.get( :blog_feed_title  ) || site_name
      maker.channel.updated = most_recent_posted_at.iso8601
    end

    def add_post( maker, post )
      maker.items.new_item do |item|
        item.title   = post.title
        item.updated = post.posted_at.iso8601
        item.summary = item_content( post )
        item.link    = "#{base_url}#{post.path}"
      end
    end

    def item_content( post )
      return post.teaser unless post.body_longer_than_teaser?

      <<~BODY
        #{post.teaser}

        <p>#{I18n.t( 'shiny_blog.atom_feed_job.read_more' )}</p>
      BODY
    end

    def base_url
      root_url.to_s.chop
    end
  end
end
