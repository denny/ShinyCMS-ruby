# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'sitemap_generator'

module ShinySEO
  # A thin wrapper around the sitemap_generator gem - part of the ShinySEO plugin for ShinyCMS
  class Sitemap
    include ShinyCMS::MainAppRootURL

    def initialize
      SitemapGenerator::Sitemap.default_host = main_app_root_url

      s3_config = ShinyCMS::S3Config.get( :feeds )

      use_aws_sdk_adapter( s3_config ) if s3_config.present?
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
      ShinyCMS.plugins.models_with_sitemap_items
              .collect( &:sitemap_items ).flatten
              .collect { |resource| SitemapItem.new( resource ) }
    end

    def use_aws_sdk_adapter( s3_config )
      require 'aws-sdk-s3'

      SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
        's3_bucket',
        aws_secret_access_key: s3_config.secret_access_key,
        aws_access_key_id:     s3_config.access_key_id,
        aws_region:            s3_config.region,
        aws_endpoint:          s3_config.base_url
      )
    end
  end
end
