# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Helper method for finding mailing lists - part of ShinyNews plugin for ShinyCMS
  module MainSiteHelper
    def recent_news_posts( count )
      ShinyNews::Post.recent.limit( count )
    end
  end
end
