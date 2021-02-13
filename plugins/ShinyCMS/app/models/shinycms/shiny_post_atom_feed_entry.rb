# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

module ShinyCMS
  # Model to assist in building Atom feed entries from ShinyPosts
  class ShinyPostAtomFeedEntry
    include ShinySiteNameHelper
    include ShinySiteURL

    include Rails.application.routes.url_helpers

    attr_reader :entry, :feed, :post

    def initialize( feed )
      @feed  = feed
      @entry = feed.class::Entry.new
      @post  = nil
    end

    def build( post )
      @post = post

      add_entry_id && add_entry_title && add_entry_author &&
        add_entry_updated && add_entry_summary && add_entry_link

      entry.parent = feed
    end

    private

    def add_entry_id
      id = entry.class::Id.new
      id.content = "#{site_base_url}#{post.path}"
      entry.id = id
    end

    def add_entry_title
      title = entry.class::Title.new
      title.content = post.title
      entry.title = title
    end

    def add_entry_author
      author = entry.class::Author.new
      name = author.class::Name.new
      name.content = post.author.name
      author.name = name
      entry.authors << author
    end

    def add_entry_updated
      updated = entry.class::Updated.new
      updated.content = post.posted_at.iso8601
      entry.updated = updated
    end

    def add_entry_summary
      summary = entry.class::Summary.new
      summary.content = html_escape( feed_entry_summary( post.teaser ) )
      summary.type = 'html'
      entry.summary = summary
    end

    def add_entry_link
      link = entry.class::Link.new
      link.href = "#{site_base_url}#{post.path}"
      entry.links << link
    end

    def feed_entry_summary( teaser )
      return teaser unless post.body_longer_than_teaser?

      <<~SUMMARY
        #{teaser}

        <p>#{I18n.t( 'models.shiny_post_atom_feed_entry.read_more' )}</p>
      SUMMARY
    end

    def html_escape( html )
      html.gsub( '&', '&amp;' ).gsub( '<', '&lt;' ).gsub( '>', '&gt;' )
    end
  end
end
