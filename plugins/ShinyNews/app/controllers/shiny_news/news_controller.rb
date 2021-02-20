# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Main site controller for news section - provided by ShinyNews plugin for ShinyCMS
  class NewsController < MainController
    include ShinyCMS::FeatureFlags

    include ShinyCMS::Paging

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
    end

    private

    def strong_params
      params.permit( :year, :month, :slug, :page, :count, :size, :per )
    end

    def post_path_params
      [ strong_params[:year], strong_params[:month], strong_params[:slug] ]
    end

    def check_feature_flags
      enforce_feature_flags :news
    end

    # Override pager link format (to news/page/NN rather than news?page=NN)
    def pagy_url_for( page, _pagy )
      params = request.query_parameters.merge( only_path: true, page: page )
      url_for( params )
    end
  end
end
