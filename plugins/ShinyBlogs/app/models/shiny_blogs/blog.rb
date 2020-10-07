# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Model class for blogs (which are a collection of blog posts) - part of the ShinyBlogs plugin for ShinyCMS
  class Blog < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinyShowHide
    include ShinySlug

    # Associations

    belongs_to :user, inverse_of: :shiny_blogs_blogs

    has_many :all_posts, inverse_of: :blog, class_name: 'BlogPost', dependent: :restrict_with_error

    # Plugins

    paginates_per 20

    # Aliases

    alias_attribute :owner, :user

    # Instance methods

    def posts
      all_posts.readonly.published
    end

    def posts_in_month( year, month )
      month = Date.new( year.to_i, month.to_i, 1 )
      posts.where( posted_at: month.all_month ).published.readonly.order( :posted_at )
    end

    def posts_in_year( year_string )
      year = Date.new( year_string.to_i, 1, 1 )
      posts.where( posted_at: year.all_year ).published.readonly.order( :posted_at )
    end

    def find_post( year, month, slug )
      posts_in_month( year, month ).find_by( slug: slug )
    end
  end
end

# Add inverse association for owners of blogs
::User.has_many :shiny_blogs_blogs, dependent: :restrict_with_error, class_name: 'ShinyBlogs::Blog'
