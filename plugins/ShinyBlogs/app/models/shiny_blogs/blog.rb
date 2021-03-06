# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Model class for blogs (which are a collection of blog posts) - part of the ShinyBlogs plugin for ShinyCMS
  class Blog < ApplicationRecord
    include ShinyCMS::ProvidesDemoSiteData
    include ShinyCMS::HasPublicName
    include ShinyCMS::CanHide
    include ShinyCMS::HasSlug
    include ShinyCMS::SoftDelete

    belongs_to :user, inverse_of: :shiny_blogs_blogs, class_name: 'ShinyCMS::User'

    has_many :all_posts, inverse_of: :blog, class_name: 'BlogPost', dependent: :restrict_with_error

    alias_attribute :owner, :user

    alias slug_base name

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
ShinyCMS::User.has_many :shiny_blogs_blogs, dependent: :restrict_with_error, class_name: 'ShinyBlogs::Blog'
