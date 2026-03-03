# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for dealing with Akismet
  module WithAkismet
    def akismet_api_key_is_set?
      ENV[ 'AKISMET_API_KEY' ].present?
    end

    def akismet_check( request, content )
      # Akismet::Client will throw "Akismet::Error: unknown error" if API key is invalid
      akismet_client.check( request, content )
    end

    def akismet_confirm_spam( comment_ids )
      akismet_client.train_as_spam( Comment.where( id: comment_ids ) )
    end

    def akismet_flag_as_ham( comment_ids )
      akismet_client.train_as_ham( Comment.where( id: comment_ids ) )
    end

    private

    def akismet_client
      ShinyCMS::AkismetClient.new
    end
  end
end
