# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Model for news posts, from ShinyNews plugin for ShinyCMS
  class Post < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPost

    # Associations

    belongs_to :user, inverse_of: :news_posts

    has_one :discussion, as: :resource, dependent: :destroy

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_news_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end

    # Specify policy class for Pundit
    def policy_class
      self.class.policy_class
    end

    # Class methods

    def self.human_name
      'news post'
    end

    def self.policy_class
      ShinyNews::PostPolicy
    end
  end
end

# Add inverse association for authors of news posts
::User.has_many :news_posts, dependent: :restrict_with_error, class_name: 'ShinyNews::Post'
