# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlogs plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/app/controllers/admin/blog/posts_controller.rb
# Purpose:   Controller for blog posts in ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyBlogs
  # Admin controller for blog posts, from ShinyBlogs plugin for ShinyCMS
  class Admin::Blog::PostsController < AdminController
    before_action :set_blog
    before_action :set_post_for_create, only: %i[ create ]
    before_action :set_post, only: %i[ edit update destroy ]
    before_action :update_discussion_flags, only: %i[ create update ]

    def index
      authorize BlogPost

      page_num = params[ :page ] || 1
      @posts = @blog.all_posts.order( :created_at ).page( page_num )

      authorize @posts.first if @posts.present?
    end

    def new
      @post = @blog.posts.new
      authorize @post
    end

    def create
      authorize @post

      if @post.save
        redirect_to edit_blog_post_path( @blog, @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      return unless authorize @post
    end

    def update
      return unless authorize @post

      if @post.update( post_params )
        redirect_to edit_blog_post_path( @blog, @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def update_discussion_flags
      show_on_site = params[ :blog_post].delete( :discussion_show_on_site ) || 0
      locked = params[ :blog_post].delete( :discussion_locked ) || 0

      return true if @post.discussion.blank?

      @post.discussion.update!( show_on_site: show_on_site, locked: locked )
    end

    def destroy
      return unless authorize @post

      flash[ :notice ] = t( '.success' ) if @post.destroy

      redirect_to blog_posts_path( @blog )
    end

    # Override the breadcrumbs 'section' link to go back to the list of posts for this blog
    def breadcrumb_link_text_and_path
      [ t( 'shiny_blogs.admin.blog.posts.title' ), blog_posts_path( @blog ) ]
    end

    private

    def set_blog
      @blog = ShinyBlogs::Blog.find( params[:blog_id] )
      # rescue ActiveRecord::RecordNotFound
      # skip_authorization
      # redirect_to blogs_path, alert: t( '.failure' )
    end

    def set_post
      @post = @blog.all_posts.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to blog_posts_path( @blog ), alert: t( '.failure' )
    end

    def post_params
      params[ :blog_post ].delete( :user_id ) unless current_user.can? :change_author, :blog_posts

      params.require( :blog_post ).permit(
        :blog_id, :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )
    end

    def set_post_for_create
      @post = @blog.posts.new( post_params_for_create )
    end

    def post_params_for_create
      params[ :blog_post ][ :user_id ] = current_user.id unless current_user.can? :change_author, :blog_posts

      params.require( :blog_post ).permit(
        :blog_id, :user_id, :title, :slug, :tag_list, :posted_at, :body, :show_on_site,
        :discussion_show_on_site, :discussion_locked
      )
    end
  end
end
