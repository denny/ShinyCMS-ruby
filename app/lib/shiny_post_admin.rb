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
  def atom_feed_file_path( feed_name )
    Rails.root.join( "public/feeds/atom/#{feed_name}.xml" ).to_s
  end

  def write_feed( feed_name, feed )
    file_path = atom_feed_file_path( feed_name )

    File.open file_path, 'w' do |f|
      f.write feed.to_s
      f.write "\n"
    end
  end

  def build_feed( feed_name, posts )
    RSS::Maker.make( 'atom' ) do |feed|
      add_channel_details_to_feed( feed_name, posts.first.posted_at, feed )

      posts.each do |post|
        add_post_to_feed( post, feed )
      end
    end
  end

  def add_channel_details_to_feed( feed_name, most_recent_posted_at, feed )
    feed.channel.about   = "#{base_url}/feeds/atom/#{feed_name}.xml"
    feed.channel.author  = Setting.get( "#{feed_name}_feed_author" ) || site_name
    feed.channel.title   = Setting.get( "#{feed_name}_feed_title"  ) || site_name
    feed.channel.updated = most_recent_posted_at.iso8601
  end

  def add_post_to_feed( post, feed )
    feed.items.new_item do |item|
      item.title   = post.title
      item.updated = post.posted_at.iso8601
      item.summary = feed_item_content( post )
      item.link    = "#{base_url}#{post.path}"
    end
  end

  def feed_item_content( post )
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
