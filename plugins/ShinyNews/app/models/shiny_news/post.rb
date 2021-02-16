# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Model for news posts, from ShinyNews plugin for ShinyCMS
  class Post < ApplicationRecord
    include ShinyCMS::ShinyDemoDataProvider
    include ShinyCMS::ShinyPost

    # Associations

    belongs_to :user, inverse_of: :news_posts, class_name: 'ShinyCMS::User'

    has_one :discussion, as: :resource, dependent: :destroy, class_name: 'ShinyCMS::Discussion'

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_news_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end
  end
end

# Add inverse association for authors of news posts
ShinyCMS::User.has_many :news_posts, dependent: :restrict_with_error, class_name: 'ShinyNews::Post'
