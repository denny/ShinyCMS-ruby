# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rss'

module ShinyCMS
  # Model to build an Atom feed from an array of ShinyCMS::Post records
  class AtomFeed
    include ShinyCMS::MainAppRootURL
    include ShinyCMS::SiteNameHelper

    attr_reader :name, :feed

    def initialize( feed_name )
      @name = feed_name

      @feed = RSS::Atom::Feed.new( '1.0', 'UTF-8', false )

      @s3_config = ShinyCMS::S3Config.get( :feeds )
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
      write_file_to_aws_s3 || write_file_to_local_disk( Rails.root.join( "public/feeds/atom/#{name}.xml" ) )
    end

    private

    def write_file_to_local_disk( file_path )
      feed_text = feed.to_feed( 'atom' )

      File.open file_path, 'w' do |feed_file|
        feed_file.write "#{feed_text}\n"
      end
    end

    def write_file_to_aws_s3
      return if @s3_config.blank?

      # TODO: mock this
      # :nocov:
      s3 = s3_resource

      write_file_to_local_disk "/tmp/#{name}.xml"

      obj = s3.bucket( @s3_config.bucket ).object( "feeds/atom/#{name}.xml" )
      obj.upload_file( "/tmp/#{name}.xml" )
      obj.acl.put( { acl: 'public-read' } )
      # :nocov:
    end

    def s3_resource
      # :nocov:
      Aws::S3::Resource.new(
        secret_access_key: @s3_config.secret_access_key,
        access_key_id:     @s3_config.access_key_id,
        region:            @s3_config.region
      )
      # :nocov:
    end

    def add_post_to_feed( post )
      feed_entry = ShinyCMS::AtomFeedEntry.new( feed )

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

    def feeds_base_url
      @s3_config&.custom_url || @s3_config&.base_url || main_app_base_url
    end
  end
end
