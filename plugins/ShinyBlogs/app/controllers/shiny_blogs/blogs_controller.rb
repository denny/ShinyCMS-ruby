# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlogs plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/app/controllers/blog_controller.rb
# Purpose:   Controller for blog features on a ShinyCMS-powered site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyBlogs
  # Main site controller for ShinyBlogs plugin for ShinyCMS
  class BlogsController < ApplicationController
    before_action :check_feature_flags
    before_action :set_blog, except: :index

    def index
      # :nocov:
      @blogs = ShinyBlogs::Blog.readonly.all
      # :nocov:
    end

    def recent
      page_num = params[:page] || 1
      @posts = @blog.recent_posts.page( page_num )
    end

    def month
      @posts = @blog.posts_in_month( params[:year], params[:month] )
    end

    def year
      @posts = @blog.posts_in_year( params[:year] )
    end

    def show
      @post = @blog.find_post( params[:year], params[:month], params[:slug] )
      return if @post.present?

      @resource_type = 'Blog post'
      render 'errors/404', status: :not_found
    end

    private

    def set_blog
      @blog =
        if ShinyBlogs::Blog.multiple_blogs_mode?
          # :nocov:
          ShinyBlogs::Blog.readonly.find( params[:blog_slug] )
          # :nocov:
        else
          ShinyBlogs::Blog.readonly.first
        end
      return if @blog.present?

      flash[ :alert ] = t( 'shiny_blogs.blogs.set_blog.failure' )
      redirect_to main_app.root_path
    end

    def check_feature_flags
      enforce_feature_flags :shiny_blogs
    end
  end
end
