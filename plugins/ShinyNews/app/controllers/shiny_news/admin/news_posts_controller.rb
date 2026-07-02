# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Admin area controller for ShinyNews plugin for ShinyCMS
  class Admin::NewsPostsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithPosts

    before_action :set_post_for_create, only: :create
    before_action :set_post, only: %i[ edit update destroy ]

    def index
      authorize Post

      @pagy, @posts = pagy( Post.order( posted_at: :desc ) )

      authorize @posts if @posts.present?
    end

    def search
      authorize Post

      @pagy, @posts = pagy( Post.admin_search( params[:q] ) )

      authorize @posts if @posts.present?
      render :index
    end

    def new
      @post = Post.new
      authorize @post
    end

    def create
      authorize @post

      if @post.save
        redirect_to shiny_news.edit_news_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @post
    end

    def update
      authorize @post

      if @post.update( strong_params_for_update )
        redirect_to shiny_news.edit_news_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorize @post

      flash[ :notice ] = t( '.success' ) if @post.destroy
      redirect_to news_posts_path
    end

    private

    def set_post
      @post = Post.find( params[:id] )
    end

    def set_post_for_create
      show, lock = extract_discussion_flags_from_params( params[:post] )

      @post = Post.new( strong_params_for_create )

      create_discussion_or_update_flags( @post, show, lock ) if show
    end

    def strong_params_for_create
      enforce_change_author_capability_for_create( :news_posts )

      temp_params = params.expect( post: %i[ title slug body tag_list show_on_site user_id posted_at posted_at_time ] )

      combine_date_and_time_params( temp_params, :posted_at )
    end

    def strong_params_for_update
      show, lock = extract_discussion_flags_from_params( params[:post] )
      create_discussion_or_update_flags( @post, show, lock )

      enforce_change_author_capability_for_update( :news_posts )

      temp_params = params.expect( post: %i[ title slug body tag_list show_on_site user_id posted_at posted_at_time ] )

      combine_date_and_time_params( temp_params, :posted_at )
    end
  end
end
