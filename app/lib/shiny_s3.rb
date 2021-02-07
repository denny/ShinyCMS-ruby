# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods for checking and using AWS S3 config from ENV
module ShinyS3
  def aws_s3_feeds_config_present?
    aws_s3_feeds_secret_access_key.present? &&
      aws_s3_feeds_access_key_id.present? &&
      aws_s3_feeds_bucket.present? &&
      aws_s3_feeds_region.present?
  end

  private

  def aws_s3_feeds_secret_access_key
    ENV[ 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ].presence
  end

  def aws_s3_feeds_access_key_id
    ENV[ 'AWS_S3_FEEDS_ACCESS_KEY_ID' ].presence
  end

  def aws_s3_feeds_bucket
    ENV[ 'AWS_S3_FEEDS_BUCKET' ].presence
  end

  def aws_s3_feeds_region
    ENV[ 'AWS_S3_FEEDS_REGION' ].presence
  end

  def aws_s3_feeds_base_url
    ENV[ 'AWS_S3_FEEDS_BASE_URL' ].presence || aws_s3_feeds_endpoint
  end

  def aws_s3_feeds_endpoint
    return if aws_s3_feeds_bucket.blank? || aws_s3_feeds_region.blank?

    http = ENV[ 'SHINYCMS_USE_HTTPS' ].present? ? 'https' : 'http'

    "#{http}://#{aws_s3_feeds_bucket}.s3.#{aws_s3_feeds_region}.amazonaws.com"
  end
end
