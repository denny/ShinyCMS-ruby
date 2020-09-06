# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Main site controller for news section - provided by ShinyNews plugin for ShinyCMS
  class NewsController < MainController
    before_action :check_feature_flags

    def index
      page_num = params[:page] || 1
      per_page = params[:per]  || Setting.get( :news_posts_per_page ) || 10
      @posts = ShinyNews::Post.readonly.recent.page( page_num ).per( per_page )
    end

    def month
      @posts = ShinyNews::Post.readonly.posts_in_month( params[:year], params[:month] )
    end

    def year
      @posts = ShinyNews::Post.readonly.posts_in_year( params[:year] )
    end

    def show
      @post = ShinyNews::Post.readonly.find_post( params[:year], params[:month], params[:slug] )
      return if @post.present?

      @resource_type = 'News post'
      render 'errors/404', status: :not_found
    end

    private

    def check_feature_flags
      enforce_feature_flags :news
    end
  end
end
