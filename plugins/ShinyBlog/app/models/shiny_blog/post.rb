# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Model for blog posts, from ShinyBlog plugin for ShinyCMS
  class Post < ApplicationRecord
    include ShinyCMS::Post

    include ShinyCMS::ProvidesDemoSiteData
    include ShinyCMS::ProvidesSitemapData

    belongs_to :user, inverse_of: :blog_posts, class_name: ShinyCMS.config_user_model

    # Add inverse association for authors of blog posts
    user_model = ShinyCMS.config_user_model
    user_model.constantize.has_many :blog_posts, dependent:  :restrict_with_error, class_name: 'ShinyBlog::Post'

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :title, :body, :slug  # TODO: author
    end

    def path( anchor: nil )
      url_helpers.view_blog_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end
  end
end
