# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Admin area controller for ShinyNews plugin for ShinyCMS
  class Admin::NewsPostsController < AdminController
    before_action :set_post_for_create, only: :create
    before_action :set_post, only: %i[ edit update destroy ]

    def index
      authorise ShinyNews::Post
      page_num = params[ :page ] || 1
      @posts = ShinyNews::Post.order( :created_at ).page( page_num )
      authorise @posts if @posts.present?
    end

    def new
      @post = ShinyNews::Post.new
      authorise @post
    end

    def create
      authorise @post

      if @post.save
        redirect_to shiny_news.edit_news_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorise @post
    end

    def update
      authorise @post

      if @post.update( post_params )
        redirect_to shiny_news.edit_news_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorise @post

      flash[ :notice ] = t( '.success' ) if @post.destroy
      redirect_to news_posts_path
    end

    private

    def set_post
      @post = ShinyNews::Post.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to news_posts_path, alert: t( 'shiny_news.admin.news_posts.set_post.not_found' )
    end

    def post_params
      permitted_params = params.require( :post ).permit(
        :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )

      permitted_params.delete( :user_id ) unless current_user.can? :change_author, :news_posts

      update_discussion_flags( permitted_params )
    end

    def set_post_for_create
      @post = ShinyNews::Post.new( post_params_for_create )
    end

    def post_params_for_create
      permitted_params = params.require( :post ).permit(
        :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )

      # permitted_params = update_discussion_flags( permitted_params )

      only_allow_admins_to_set_author( permitted_params )
    end

    def only_allow_admins_to_set_author( permitted_params )
      permitted_params[ :user_id ] = current_user.id unless current_user.can? :change_author, :news_posts
      permitted_params
    end

    def update_discussion_flags( permitted_params )
      show_on_site = permitted_params.delete( :discussion_show_on_site ) || 0
      locked = permitted_params.delete( :discussion_locked ) || 0

      return permitted_params if @post.discussion.blank?

      @post.discussion.update!( show_on_site: show_on_site, locked: locked )
      permitted_params
    end
  end
end
