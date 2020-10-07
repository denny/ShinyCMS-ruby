# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Model class for blog posts - ShinyBlogs plugin for ShinyCMS
  class BlogPost < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPost

    # Associations

    belongs_to :blog, inverse_of: :all_posts, class_name: 'ShinyBlogs::Blog'
    belongs_to :user, inverse_of: :shiny_blogs_blog_posts

    has_one :discussion, as: :resource, dependent: :destroy

    # Validations

    validates :blog, presence: true

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_blog_post_path(
        blog.slug, posted_year, posted_month, slug, anchor: anchor
      )
    end
  end
end

# Add inverse association for authors of blog posts
::User.has_many :shiny_blogs_blog_posts, dependent: :restrict_with_error, class_name: 'ShinyBlogs::BlogPost'
