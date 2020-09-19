# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Admin area controller for ShinyNews plugin for ShinyCMS
  class Admin::NewsPostsController < AdminController
    include ShinyDateHelper
    include ShinyPagingHelper

    before_action :set_post_for_create, only: :create
    before_action :set_post, only: %i[ edit update destroy ]

    def index
      authorise Post
      @posts = Post.order( created_at: :desc ).page( page_number )
      authorise @posts if @posts.present?
    end

    def new
      @post = Post.new
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

      if @post.update( strong_params_for_update )
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
      @post = Post.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to news_posts_path, alert: t( 'shiny_news.admin.news_posts.set_post.not_found' )
    end

    def strong_params_for_update
      temp_params = params.require( :post ).permit(
        :title, :slug, :body, :tag_list, :show_on_site, :user_id, :posted_at, :posted_at_time,
        :discussion_show_on_site, :discussion_locked
      )

      temp_params = combine_date_and_time_inputs( temp_params, :posted_at )

      temp_params.delete( :user_id ) unless current_user.can? :change_author, :news_posts

      update_discussion_flags( temp_params )
    end

    def set_post_for_create
      @post = Post.new( strong_params_for_create )
    end

    def strong_params_for_create
      temp_params = params.require( :post ).permit(
        :title, :slug, :body, :tag_list, :show_on_site, :user_id, :posted_at, :posted_at_time,
        :discussion_show_on_site, :discussion_locked
      )

      temp_params = combine_date_and_time_inputs( temp_params, :posted_at )

      # temp_params = update_discussion_flags( temp_params )

      only_allow_admins_to_set_author( temp_params )
    end

    def only_allow_admins_to_set_author( temp_params )
      temp_params[ :user_id ] = current_user.id unless current_user.can? :change_author, :news_posts
      temp_params
    end

    def update_discussion_flags( temp_params )
      show_on_site = temp_params.delete( :discussion_show_on_site ) || 0
      locked = temp_params.delete( :discussion_locked ) || 0

      return temp_params if @post.discussion.blank?

      @post.discussion.update!( show_on_site: show_on_site, locked: locked )
      temp_params
    end
  end
end
