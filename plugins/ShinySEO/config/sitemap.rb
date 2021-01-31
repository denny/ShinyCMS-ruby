# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# If a plugin wants to add items to the sitemap, the relevant model(s) should have
# a `sitemap_items` class method which returns an array of `ShinySEO::SitemapItem`s,
# and a `.path` instance method (which SitemapItem uses to build a link to the item)

s3_access_key_id = ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ]

if s3_access_key_id.present? && 1.zero?
  require 'aws-sdk-s3'

  s3_bucket = ENV[ 'AWS_S3_FEEDS_BUCKET' ]
  s3_region = ENV[ 'AWS_S3_FEEDS_REGION' ]
  s3_endpoint = "https://#{s3_bucket}.s3.#{s3_region}.amazonaws.com"

  SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
    's3_bucket',
    aws_access_key_id:     s3_access_key_id,
    aws_secret_access_key: ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ],
    aws_endpoint:          s3_endpoint,
    aws_region:            s3_region
  )
end

# Set the host name for URL creation
hostname = ENV[ 'SITE_HOSTNAME'     ].presence || 'localhost:3000'
protocol = ENV[ 'SITE_URL_PROTOCOL' ].presence || 'https'
protocol = 'http' if Rails.env.development? || Rails.env.test?

SitemapGenerator::Sitemap.default_host =
  Rails.application.routes.url_helpers.root_url( host: hostname, protocol: protocol )

SitemapGenerator::Sitemap.create do
  # Add content from each plugin model that provides it
  # (there isn't any sitemap-worthy content in main app)
  ShinyPlugin.models_with_sitemap_items.each do |model|
    model.sitemap_items.each do |item|
      add item.url, lastmod: item.content_updated_at, changefreq: item.check_for_updates
    end
  end
end
