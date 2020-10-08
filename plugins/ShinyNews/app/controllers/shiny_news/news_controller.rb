# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Main site controller for news section - provided by ShinyNews plugin for ShinyCMS
  class NewsController < MainController
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

      render 'errors/404', status: :not_found, locals: { resource_type: I18n.t( 'models.names.shiny_news_post' ) }
    end

    private

    def strong_params
      params.permit( :year, :month, :slug, :page, :count, :size, :per )
    end

    def check_feature_flags
      enforce_feature_flags :news
    end
  end
end
