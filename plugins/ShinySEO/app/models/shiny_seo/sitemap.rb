# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # A thin wrapper around the sitemap_generator gem - part of the ShinySEO plugin for ShinyCMS
  class Sitemap
    def self.generate
      SitemapGenerator::Sitemap.default_host = base_url

      use_aws_sdk_adapter if aws_s3_feeds_secret_access_key.present?

      SitemapGenerator::Sitemap.create do
        ShinyPlugin.models_with_sitemap_items.each do |model|
          model.sitemap_items.each do |item|
            add item.url, lastmod: item.content_updated_at, changefreq: item.update_frequency
          end
        end
      end
    end

    def self.base_url
      hostname = ENV[ 'SITE_HOSTNAME'     ].presence || 'localhost:3000'
      protocol = ENV[ 'SITE_URL_PROTOCOL' ].presence || 'https'
      protocol = 'http' if Rails.env.development? || Rails.env.test?

      Rails.application.routes.url_helpers.root_url( host: hostname, protocol: protocol )
    end

    class << self
      private

      def aws_sdk_config_present?
        ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ] && ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ] &&
          ENV[ 'AWS_S3_FEEDS_BUCKET' ] && ENV[ 'AWS_S3_FEEDS_REGION' ]
      end

      def use_aws_sdk_adapter
        require 'aws-sdk-s3'

        SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
          's3_bucket',
          aws_secret_access_key: aws_s3_feeds_secret_access_key,
          aws_access_key_id:     ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ],
          aws_region:            ENV[ 'AWS_S3_FEEDS_REGION' ],
          aws_endpoint:          s3_endpoint
        )
      end

      def s3_endpoint
        s3_bucket = ENV[ 'AWS_S3_FEEDS_BUCKET' ]
        s3_region = ENV[ 'AWS_S3_FEEDS_REGION' ]

        "https://#{s3_bucket}.s3.#{s3_region}.amazonaws.com"
      end

      def aws_s3_feeds_secret_access_key
        ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ].presence
      end
    end
  end
end
