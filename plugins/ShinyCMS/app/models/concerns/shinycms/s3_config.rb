# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model to wrap AWS S3 config - picks up details from ENV (TODO: and/or site settings)
  class S3Config
    self <<
      def present?( label )
        secret_access_key( label ).present? &&
        access_key_id( label ).present? &&
        bucket( label ).present? &&
        region( label ).present?
      end

    private

    def secret_access_key( label )
      ENV[ "AWS_S3_#{label.capitalize}_SECRET_ACCESS_KEY" ].presence
    end

    def access_key_id( label )
      ENV[ "AWS_S3_#{label.capitalize}_ACCESS_KEY_ID" ].presence
    end

    def bucket( label )
      ENV[ "AWS_S3_#{label.capitalize}_BUCKET" ].presence
    end

    def region( label )
      ENV[ "AWS_S3_#{label.capitalize}_REGION" ].presence
    end

    def base_url( label )
      ENV[ "AWS_S3_#{label.capitalize}_BASE_URL" ].presence || endpoint( label )
    end

    def endpoint( label )
      return if bucket( label ).blank? || region( label ).blank?

      http = ENV[ 'SHINYCMS_USE_HTTPS' ].present? ? 'https' : 'http'

      "#{http}://#{bucket( label )}.s3.#{region( label )}.amazonaws.com"
    end
  end
end
