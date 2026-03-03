# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for templates dealing with discussions and comments
  module DiscussionsHelper
    def allow_anonymous_comments?
      Setting.true?( :allow_anonymous_comments )
    end

    def allow_unauthenticated_comments?
      Setting.true?( :allow_unauthenticated_comments )
    end

    def recent_comments_by_user( user, count = 10 )
      Comment.readonly.where( author: user ).recent.limit( count )
    end
  end
end
