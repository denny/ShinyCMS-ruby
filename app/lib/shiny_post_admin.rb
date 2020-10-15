# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

# Methods that any admin controller handling ShinyPosts might want
module ShinyPostAdmin
  include ShinySiteNameHelper

  def enforce_change_author_capability_for_create( category )
    params[ :post ][ :user_id ] = current_user.id unless current_user.can? :change_author, category
  end

  def enforce_change_author_capability_for_update( category )
    params[ :post ].delete( :user_id ) unless current_user.can? :change_author, category
  end

  # Methods for building an Atom feed from a collection of posts
  def write_feed( feed_name, feed )
    file_path = Rails.root.join( "public/feeds/atom/#{feed_name}.xml" )

    File.open file_path, 'w' do |f|
      f.write feed.to_feed( 'atom' )
    end
  end

  def build_feed( feed_name, posts )
    feed = RSS::Atom::Feed.new( '1.0', 'UTF-8', false )

    add_feed_info( feed, feed_name, posts.first.posted_at )

    posts.each do |post|
      add_post_to_feed( feed, post )
    end

    feed
  end

  def add_feed_info( feed, feed_name, most_recent_posted_at )
    feed_id( feed, feed_name )
    feed_title( feed )
    feed_author( feed )
    feed_updated( feed, most_recent_posted_at )
  end

  def feed_id( feed, feed_name )
    id = feed.class::Id.new
    id.content = "#{base_url}/feeds/atom/#{feed_name}.xml"
    feed.id = id
  end

  def feed_title( feed )
    title = feed.class::Title.new
    title.content = site_name # TODO
    feed.title = title
  end

  def feed_author( feed )
    author = feed.class::Author.new
    name = author.class::Name.new
    name.content = site_name # TODO
    author.name = name
    feed.authors << author
  end

  def feed_updated( feed, most_recent_posted_at )
    updated = feed.class::Updated.new
    updated.content = most_recent_posted_at.iso8601
    feed.updated = updated
  end

  def add_post_to_feed( feed, post )
    entry = feed.class::Entry.new

    entry_id( entry, post )
    entry_title( entry, post )
    entry_author( entry, post )
    entry_updated( entry, post )
    entry_summary( entry, post )
    entry_link( entry, post )

    entry.parent = feed
    feed.entries << entry
  end

  def entry_id( entry, post )
    id = entry.class::Id.new
    id.content = "#{base_url}#{post.path}"
    entry.id = id
  end

  def entry_title( entry, post )
    title = entry.class::Title.new
    title.content = post.title
    entry.title = title
  end

  def entry_author( entry, post )
    author = entry.class::Author.new
    name = entry.class::Author::Name.new
    name.content = post.author.name
    author.name = name
    entry.authors << author
  end

  def entry_updated( entry, post )
    updated = entry.class::Updated.new
    updated.content = post.posted_at.iso8601
    entry.updated = updated
  end

  def entry_summary( entry, post )
    summary = entry.class::Summary.new
    summary.content = feed_item_summary( post )
    summary.type = 'html'
    entry.summary = summary
  end

  def entry_link( entry, post )
    link = entry.class::Link.new
    link.href = "#{base_url}#{post.path}"
    entry.links << link
  end

  def feed_item_summary( post )
    return post.teaser unless post.body_longer_than_teaser?

    "#{post.teaser}<p>#{I18n.t( 'shiny_blog.atom_feed_job.read_more' )}</p>"
  end

  def base_url
    root_url.to_s.chop
  end
end
