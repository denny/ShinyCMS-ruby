# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

# Model to assist in building Atom feeds from ShinyPosts
class ShinyPostAtomFeed
  include ShinySiteNameHelper

  include Rails.application.routes.url_helpers

  attr_accessor :name, :feed, :file_path

  def initialize( feed_name )
    return unless %i[ blog news ].include? feed_name

    @name = feed_name

    @feed = RSS::Atom::Feed.new( '1.0', 'UTF-8', false )

    @file_path = Rails.root.join( "public/feeds/atom/#{@name}.xml" ).to_s
  end

  def build( posts )
    add_feed_id
    add_feed_title
    add_feed_author
    add_feed_updated( posts.first.posted_at )

    posts.each do |post|
      add_post_to_feed( post )
    end
  end

  def write_file
    File.open file_path, 'w' do |f|
      f.write feed.to_feed( 'atom' )
      f.write "\n"
    end
  end

  private

  def add_post_to_feed( post )
    feed_entry = ShinyPostAtomFeedEntry.new( feed )

    feed_entry.build( post )

    feed.entries << feed_entry.entry
  end

  def add_feed_id
    id = feed.class::Id.new
    id.content = "#{base_url}/feeds/atom/#{name}.xml"
    feed.id = id
  end

  def add_feed_title
    title = feed.class::Title.new
    title.content = site_name # TODO
    feed.title = title
  end

  def add_feed_author
    author = feed.class::Author.new
    name = author.class::Name.new
    name.content = site_name # TODO
    author.name = name
    feed.authors << author
  end

  def add_feed_updated( most_recent_posted_at )
    updated = feed.class::Updated.new
    updated.content = most_recent_posted_at.iso8601
    feed.updated = updated
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def base_url
    root_url.to_s.chop
  end
end
