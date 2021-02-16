# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # A thin wrapper around the sitemap_generator gem - part of the ShinySEO plugin for ShinyCMS
  class Sitemap
    include ShinyCMS::ShinyS3
    include ShinyCMS::ShinySiteURL

    include Rails.application.routes.url_helpers

    def initialize
      SitemapGenerator::Sitemap.default_host = site_base_url

      use_aws_sdk_adapter_if_configured
    end

    def generate
      items_to_add = items_for_sitemap
      SitemapGenerator::Sitemap.create do
        items_to_add.each do |item|
          add item.path, lastmod: item.content_updated_at, changefreq: item.update_frequency
        end
      end
    end

    private

    def items_for_sitemap
      ShinyCMS::ShinyPlugin.models_with_sitemap_items
                           .collect( &:sitemap_items ).flatten
                           .collect { |resource| SitemapItem.new( resource ) }
    end

    def use_aws_sdk_adapter_if_configured
      return unless aws_s3_feeds_config_present?

      require 'aws-sdk-s3'

      SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new( 's3_bucket', **s3_config )
    end

    def s3_config
      {
        aws_secret_access_key: aws_s3_feeds_secret_access_key,
        aws_access_key_id:     aws_s3_feeds_access_key_id,
        aws_region:            aws_s3_feeds_region,
        aws_endpoint:          aws_s3_feeds_endpoint
      }
    end
  end
end
