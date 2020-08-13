# frozen_string_literal: true

# ============================================================================
# Project:   ShinyNews plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyNews/app/controllers/shiny_news/admin/news_controller.rb
# Purpose:   Admin area controller for news section
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyNews
  # Admin area controller for ShinyNews plugin for ShinyCMS
  class Admin::NewsController < AdminController
    before_action :set_post_for_create, only: :create
    before_action :set_post, only: %i[ edit update destroy ]
    before_action :update_discussion_flags, only: %i[ create update ]

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
        redirect_to shiny_news.edit_news_path( @post ), notice: t( '.success' )
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
        redirect_to shiny_news.edit_news_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def update_discussion_flags
      show_on_site, locked = extract_discussion_flags

      return if @post.discussion.blank?

      @post.discussion.update!( show_on_site: show_on_site, locked: locked )
    end

    def destroy
      authorise @post

      flash[ :notice ] = t( '.success' ) if @post.destroy
      redirect_to news_index_path
    end

    private

    def set_post
      @post = ShinyNews::Post.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to news_index_path, alert: t( '.failure' )
    end

    def post_params
      params[ :news_post ].delete( :user_id ) unless current_user.can? :change_author, :news_posts

      params.require( :news_post ).permit(
        :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )
    end

    def set_post_for_create
      @post = ShinyNews::Post.new( post_params_for_create )
    end

    def post_params_for_create
      set_current_user_as_author_unless_admin

      params.require( :news_post ).permit(
        :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )
    end

    def extract_discussion_flags
      show_on_site = params[ :news_post].delete( :discussion_show_on_site ) || 0
      locked = params[ :news_post].delete( :discussion_locked ) || 0
      [ show_on_site, locked ]
    end

    def set_current_user_as_author_unless_admin
      params[ :news_post ][ :user_id ] = current_user.id unless current_user.can? :change_author, :news_posts
    end
  end
end
