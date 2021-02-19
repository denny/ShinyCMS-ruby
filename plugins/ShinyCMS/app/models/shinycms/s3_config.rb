# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model to wrap AWS S3 config - picks up details from ENV (TODO: and/or site settings)
  class S3Config
    def initialize( label )
      @label = label.to_s
      return unless secret_access_key.present? && access_key_id.present? && bucket.present? && region.present?
    end

    def base_url
      ENV[ "AWS_S3_#{@label.upcase}_BASE_URL" ].presence || endpoint
    end

    def secret_access_key
      ENV[ "AWS_S3_#{@label.upcase}_SECRET_ACCESS_KEY" ].presence
    end

    def access_key_id
      ENV[ "AWS_S3_#{@label.upcase}_ACCESS_KEY_ID" ].presence
    end

    def bucket
      ENV[ "AWS_S3_#{@label.upcase}_BUCKET" ].presence
    end

    def region
      ENV[ "AWS_S3_#{@label.upcase}_REGION" ].presence
    end

    def endpoint
      return if bucket.blank? || region.blank?

      http = ENV[ 'SHINYCMS_USE_HTTPS' ].present? ? 'https' : 'http'

      "#{http}://#{bucket}.s3.#{region}.amazonaws.com"
    end
  end
end
