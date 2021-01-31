# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # A thin wrapper around the sitemap_generator gem - part of the ShinySEO plugin for ShinyCMS
  class Sitemap
    include Rails.application.routes.url_helpers

    def initialize
      SitemapGenerator::Sitemap.default_host = base_url

      use_aws_sdk_adapter_if_configured
    end

    def generate
      SitemapGenerator::Sitemap.create do
        ShinyPlugin.models_with_sitemap_items.each do |model|
          model.sitemap_items.each do |resource|
            item = ShinySEO::SitemapItem.new resource

            add item.path, lastmod: item.content_updated_at, changefreq: item.update_frequency
          end
        end
      end
    end

    private

    def use_aws_sdk_adapter_if_configured
      return unless s3_config_present?

      require 'aws-sdk-s3'

      SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
        's3_bucket',
        aws_secret_access_key: ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ],
        aws_access_key_id:     ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ],
        aws_region:            ENV[ 'AWS_S3_FEEDS_REGION' ],
        aws_endpoint:          s3_endpoint
      )
    end

    def s3_config_present?
      ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ].present? &&
        ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID'   ].present? &&
        ENV[ 'AWS_S3_FEEDS_BUCKET'          ].present? &&
        ENV[ 'AWS_S3_FEEDS_REGION'          ].present?
    end

    def s3_endpoint
      s3_bucket = ENV[ 'AWS_S3_FEEDS_BUCKET' ]
      s3_region = ENV[ 'AWS_S3_FEEDS_REGION' ]

      "https://#{s3_bucket}.s3.#{s3_region}.amazonaws.com"
    end

    def base_url
      root_url.to_s.chop
    end

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
