# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlog plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/app/controllers/shiny_blog/blog_controller.rb
# Purpose:   Main site controller for blog
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyBlog
  # Main site controller for blog - provided by ShinyBlog plugin for ShinyCMS
  class BlogController < ApplicationController
    before_action :check_feature_flags

    def index
      page_num = params[:page] || 1
      per_page = params[:per]  || Setting.get( :blog_posts_per_page ) || 10
      @posts = ShinyBlog::Post.readonly.recent.page( page_num ).per( per_page )
    end

    def month
      @posts = ShinyBlog::Post.readonly.posts_in_month( params[:year], params[:month] )
    end

    def year
      @posts = ShinyBlog::Post.readonly.posts_in_year( params[:year] )
    end

    def show
      @post = ShinyBlog::Post.readonly.find_post( params[:year], params[:month], params[:slug] )
      return if @post.present?

      @resource_type = 'Blog post'
      render 'errors/404', status: :not_found
    end

    private

    def check_feature_flags
      enforce_feature_flags :blog
    end
  end
end
