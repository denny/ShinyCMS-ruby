# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Main site blog features - part of the ShinyBlogs plugin for ShinyCMS
  class BlogsController < MainController
    before_action :check_feature_flags
    before_action :set_blog, except: :index

    def index
      @blogs = ShinyBlogs::Blog.readonly.all
    end

    def recent
      return set_blog_failure if @blog.blank?

      page_num = params[:page] || 1
      @posts = @blog.posts.recent.page( page_num )
    end

    def month
      return set_blog_failure if @blog.blank?

      @posts = @blog.posts_in_month( params[:year], params[:month] )
    end

    def year
      return set_blog_failure if @blog.blank?

      @posts = @blog.posts_in_year( params[:year] )
    end

    def show
      return set_blog_failure if @blog.blank?

      @post = @blog.find_post( params[:year], params[:month], params[:slug] )
      return if @post.present?

      @resource_type = 'Blog post'
      render 'errors/404', status: :not_found
    end

    private

    def set_blog
      @blog = ShinyBlogs::Blog.readonly.find_by( slug: params[:blog_slug] )
    end

    def set_blog_failure
      redirect_to view_blogs_path, alert: t( 'shiny_blogs.blogs.set_blog.failure' )
    end

    def check_feature_flags
      enforce_feature_flags :shiny_blogs
    end
  end
end
