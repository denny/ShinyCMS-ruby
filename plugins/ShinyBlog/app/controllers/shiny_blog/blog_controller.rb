# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Main site controller for blog - provided by ShinyBlog plugin for ShinyCMS
  class BlogController < MainController
    include ShinyPagingHelper

    before_action :check_feature_flags

    helper_method :pagy_url_for

    def index
      @pagy, @posts = pagy_countless( Post.readonly.recent, items: items_per_page )
    end

    def month
      @posts = Post.posts_in_month( strong_params[:year], strong_params[:month] )
    end

    def year
      @posts = Post.posts_in_year( strong_params[:year] )
    end

    def show
      @post = Post.find_post( *post_path_params )
      return if @post.present?

      render 'errors/not_found', status: :not_found, locals: { resource_type: I18n.t( 'models.names.shiny_blog_post' ) }
    end

    private

    def strong_params
      params.permit( :year, :month, :slug, :page, :count, :size, :per )
    end

    def post_path_params
      [ strong_params[:year], strong_params[:month], strong_params[:slug] ]
    end

    def check_feature_flags
      enforce_feature_flags :blog
    end

    # Override pager link format (to blog/page/NN rather than blog?page=NN)
    def pagy_url_for( page, _pagy )
      params = request.query_parameters.merge( only_path: true, page: page )
      url_for( params )
    end
  end
end
