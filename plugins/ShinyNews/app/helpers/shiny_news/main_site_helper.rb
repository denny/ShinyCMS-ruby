# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Helper method for finding mailing lists - part of ShinyNews plugin for ShinyCMS
  module MainSiteHelper
    def recent_news_posts( count = 10 )
      ShinyNews::Post.readonly.recent.limit( count )
    end

    def recent_news_posts_by_user( user, count = 10 )
      ShinyNews::Post.readonly.where( user: user ).recent.limit( count )
    end
  end
end
