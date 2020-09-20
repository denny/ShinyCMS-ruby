# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Main site controller for blog - provided by ShinyBlog plugin for ShinyCMS
  class BlogController < MainController
    include ShinyPagingHelper

    before_action :check_feature_flags

    def index
      @posts = Post.readonly.recent.page( page_number ).per( items_per_page )
    end

    def month
      @posts = Post.posts_in_month( strong_params[:year], strong_params[:month] )
    end

    def year
      @posts = Post.posts_in_year( strong_params[:year] )
    end

    def show
      @post = Post.find_post( strong_params[:year], strong_params[:month], strong_params[:slug] )
      return if @post.present?

      render 'errors/404', status: :not_found, locals: { resource_type: Post.human_name }
    end

    private

    def strong_params
      params.permit( :year, :month, :slug, :page, :count, :size, :per )
    end

    def check_feature_flags
      enforce_feature_flags :blog
    end
  end
end
