# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlog plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/app/models/shiny_blog/post.rb
# Purpose:   Model for blog posts
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyBlog
  # Model for blog posts, from ShinyBlog plugin for ShinyCMS
  class Post < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPost

    # Associations

    belongs_to :user, inverse_of: :blog_posts

    has_one :discussion, as: :resource, dependent: :destroy

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_blog_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end

    # Specify policy class for Pundit
    def policy_class
      ShinyBlog::PostPolicy
    end

    # Class methods

    def self.human_name
      'blog post'
    end

    def self.policy_class
      ShinyBlog::PostPolicy
    end
  end
end

# Add inverse association for authors of blog posts
::User.has_many :blog_posts, dependent: :restrict_with_error, class_name: 'ShinyBlog::Post'
