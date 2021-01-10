# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

# Model to assist in building Atom feeds from ShinyPosts
class ShinyPostAtomFeed
  include ShinySiteNameHelper

  include Rails.application.routes.url_helpers

  attr_reader :name, :feed

  def initialize( feed_name )
    return unless %i[ blog news ].include? feed_name

    @name = feed_name

    @feed = RSS::Atom::Feed.new( '1.0', 'UTF-8', false )
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
    write_file_to_aws_s3 || write_file_to_local_disk( Rails.root.join( "public/feeds/atom/#{name}.xml".to_s ) )
  end

  private

  def write_file_to_local_disk( file_path )
    feed_text = feed.to_feed( 'atom' )

    File.open file_path, 'w' do |feed_file|
      feed_file.write "#{feed_text}\n"
    end
  end

  def write_file_to_aws_s3
    return if aws_s3_feeds_bucket.blank?

    # TODO: mock this
    # :nocov:
    s3 = Aws::S3::Resource.new(
      region:            aws_s3_feeds_region,
      access_key_id:     aws_s3_feeds_access_key_id,
      secret_access_key: aws_s3_feeds_secret_access_key
    )

    write_file_to_local_disk "/tmp/#{name}.xml"

    obj = s3.bucket( aws_s3_feeds_bucket ).object( "feeds/atom/#{name}.xml" )
    obj.upload_file( "/tmp/#{name}.xml" )
    obj.acl.put( { acl: 'public-read' } )
    # :nocov:
  end

  def add_post_to_feed( post )
    feed_entry = ShinyPostAtomFeedEntry.new( feed )

    feed_entry.build( post )

    feed.entries << feed_entry.entry
  end

  def add_feed_id
    id = feed.class::Id.new
    id.content = "#{feeds_base_url}/feeds/atom/#{name}.xml"
    feed.id = id
  end

  def add_feed_title
    title = feed.class::Title.new
    title.content = site_name # TODO
    feed.title = title
  end

  def add_feed_author
    author = feed.class::Author.new
    author_name = author.class::Name.new
    author_name.content = site_name # TODO
    author.name = author_name
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

  def feeds_base_url
    aws_s3_base_url || root_url.to_s.chop
  end

  def aws_s3_base_url
    return if aws_s3_feeds_bucket.blank?

    http = ENV[ 'MAILER_URL_PROTOCOL' ].presence || 'https'

    "#{http}://#{aws_s3_feeds_domain}"
  end

  def aws_s3_feeds_bucket
    ENV[ 'AWS_S3_FEEDS_BUCKET' ].presence
  end

  def aws_s3_feeds_region
    ENV[ 'AWS_S3_FEEDS_REGION' ].presence
  end

  def aws_s3_feeds_access_key_id
    ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ].presence
  end

  def aws_s3_feeds_secret_access_key
    ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ].presence
  end

  def aws_s3_feeds_domain
    ENV[ 'AWS_S3_FEEDS_DOMAIN' ].presence || "#{aws_s3_feeds_bucket}.s3.#{aws_s3_feeds_region}.amazonaws.com"
  end
end
