# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model to wrap AWS S3 config - picks up details from ENV (TODO: and/or site settings)
  class S3Config
    def initialize( label )
      @label = label.to_s
    end

    def self.get( label )
      config = new( label )

      if config.secret_access_key.blank? || config.access_key_id.blank? || config.bucket.blank? || config.region.blank?
        return
      end

      config
    end

    def secret_access_key
      ENV.fetch( "AWS_S3_#{@label.upcase}_SECRET_ACCESS_KEY", nil )
    end

    def access_key_id
      ENV.fetch( "AWS_S3_#{@label.upcase}_ACCESS_KEY_ID", nil )
    end

    def bucket
      ENV.fetch( "AWS_S3_#{@label.upcase}_BUCKET", nil )
    end

    def region
      ENV.fetch( "AWS_S3_#{@label.upcase}_REGION", nil )
    end

    # Note that if you configure a custom URL, the USE_HTTPS setting is irrelevant
    def custom_url
      ENV.fetch( "AWS_S3_#{@label.upcase}_CUSTOM_URL", nil ).presence&.sub( %r{/$}, '' )
    end

    def base_url
      return if bucket.blank? || region.blank?

      http = use_https? ? 'https' : 'http'

      "#{http}://#{bucket}.s3.#{region}.amazonaws.com"
    end

    def use_https?
      Rails.application.config.force_ssl ||
        ENV.fetch( 'SHINYCMS_USE_HTTPS', nil ).presence&.casecmp( 'true' )&.zero?
    end
  end
end
